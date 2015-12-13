require "rails_helper"

RSpec.feature "AdminDashboards", type: :feature do
  before(:all) do
    full_setup
  end

  before(:each) do
    login_as @admin
  end

  shared_examples_for "an admin resource" do |resource|
    before(:each) do
      @plural_resource = resource.pluralize
      @class_name = resource.classify.constantize
      visit send("admin_#{@plural_resource}_path")
    end

    it "lists #{@plural_resource}" do
      expect(page).to have_text(instance_variable_get("@"+resource).name)
    end

    it "deletes #{resource}" do
      expect {
        click_link("Удалить", match: :first)
      }.to change(@class_name, :count).by(-1)
    end

    it "adds #{resource}" do
      click_link "Создать"
      fill_in "Имя", with: resource + " 2"

      if resource == "user"
        fill_in "Эл. почта", with: "test@example.com"
        fill_in "Пароль", with: "test1234"
        fill_in "Подтверждение пароля", with: "test1234"
      end

      expect {
        click_button "Сохранить"
      }.to change(@class_name, :count).by(1)
      expect(@class_name.first.name).to eq(resource + " 2")
    end

    it "edits #{resource}" do
      click_link "Редактировать", match: :first
      fill_in "Имя", with: "Измененный " + resource
      click_button "Сохранить"

      name = @class_name.order(updated_at: :desc).first.name

      expect(name).to eq("Измененный " + resource)
    end
  end

  describe "stadiums" do
    it_behaves_like "an admin resource", "stadium"
  end

  describe "users" do
    it_behaves_like "an admin resource", "user"
  end
end

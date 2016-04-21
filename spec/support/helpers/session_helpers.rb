module Features
  module SessionHelpers
    def sign_up_with(name, email, password, confirmation, type = nil)
      visit new_user_session_path
      within ".new_registration" do
        fill_in "Имя", with: name
        fill_in "Эл. почта", with: email
        fill_in "Пароль", with: password
        fill_in "Подтверждение пароля", :with => confirmation
        select type, from: "Тип" if type
        check "Согласен с пользовательским соглашением"
      end
      click_button "Зарегистрироваться"
    end

    def signin(email, password)
      visit new_user_session_path
      within ".new_session" do
        fill_in "Эл. почта", with: email
        fill_in "Пароль", with: password
      end
      page.execute_script('$(".new_session input[name=\'commit\']").trigger("click")')
      sleep 0.5
    end
  end
end

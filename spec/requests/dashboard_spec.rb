require 'rails_helper'

RSpec.describe "Dashboard" do
  context "StadiumUser" do
    before(:all) do
      @user = StadiumUser.create({
        email: 'stadium@example.com',
        password: 'blinkenbleg'
      })

      @court = Court.create({
        stadium: Stadium.create(user: @user),
        price: 100
      })

      login_via_post_as(@user)
    end

    %w(dashboard_grid_path
      dashboard_coach_users_path
      paid_my_events_path
      edit_dashboard_product_path
      dashboard_withdrawal_requests_path).each do |path|

      it "visits #{path}" do
        get send(path)

        expect(response.status).to eq(200)
      end
    end
  end
  context "CoachUser" do
    before(:all) do
      @user = CoachUser.create({
        email: 'coach@example.com',
        password: 'blinkenbleg'
      })

      @coach = Coach.create({
        price: 100,
        user: @user
      })

      login_via_post_as @user
    end

    %w(dashboard_grid_path
      dashboard_employments_path
      dashboard_customers_path
      deposit_requests_path
      edit_dashboard_product_path).each do |path|

      it "visits #{path}" do
        get send(path)

        expect(response.status).to eq(200)
      end
    end
  end
end

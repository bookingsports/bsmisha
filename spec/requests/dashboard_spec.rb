require 'rails_helper'

RSpec.describe "Dashboard" do
  context "StadiumUser" do
    let(:user) {create(:stadium_user)}
    let(:area) {user.stadium.area.first}

    %w(dashboard_grid_path
      dashboard_coach_users_path
      paid_my_events_path
      edit_dashboard_product_path
      dashboard_withdrawal_requests_path).each do |path|

      it "visits #{path}" do
        login_via_post_as(user)
        get send(path)

        expect(response.status).to eq(200)
      end
    end
  end
  context "CoachUser" do
    let(:user) {create(:coach_user)}
    let(:coach) {coach_user.coach}

    %w(dashboard_grid_path
      dashboard_employments_path
      dashboard_customers_path
      deposit_requests_path
      edit_dashboard_product_path).each do |path|

      it "visits #{path}" do
        login_via_post_as(user)
        get send(path)

        expect(response.status).to eq(200)
      end
    end
  end
end

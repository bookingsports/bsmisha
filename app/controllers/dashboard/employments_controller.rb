class Dashboard::EmploymentsController < DashboardController
  before_filter :check_if_user_is_coach_user!

  def index
    @coach = current_user.coach.present? ? current_user.coach : current_user.build_coach
    @areas = @coach.coaches_areas
  end

  def create
    @area = Area.find(params[:coaches_area][:area_id])
    @coach = current_user.coach.present? ? current_user.coach : current_user.build_coach
    @coach.coaches_areas.new area: @area, price: params[:coaches_area][:price], stadium_percent: params[:coaches_area][:stadium_percent]
    @coach.save

    redirect_to dashboard_employments_path
  end

  def destroy
    current_user.coach.coaches_areas.find(params[:id]).destroy
    redirect_to dashboard_employments_path
  end

  private

    def check_if_user_is_coach_user!
      if current_user.type != "CoachUser"
        redirect_to root_url
      end
    end
end
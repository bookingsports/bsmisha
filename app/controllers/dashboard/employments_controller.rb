class Dashboard::EmploymentsController < DashboardController
  def index
    @areas = current_user.coach.coaches_areas
  end

  def create
    @area = Area.find(params[:coaches_area][:area_id])
    current_user.coach.coaches_areas.new area: @area, price: params[:coaches_area][:price]
    current_user.coach.save

    redirect_to dashboard_employments_path
  end

  def destroy
    current_user.coach.coaches_areas.find(params[:id]).delete

    redirect_to dashboard_employments_path
  end
end
class Dashboard::Coach::CoachesController < DashboardController
  before_filter :find_coach

  def edit
  end

  def update
    @coach.update coach_params

    render :edit
  end

  private

    def find_coach
      @coach_user = current_user
      @coach = current_user.coach
    end

    def coach_params
      params.require(:coach).permit(:name, :password, :password_confirmation, :email, :price, :phone, :avatar, court_ids: [], profile_attributes: [:description])
    end
end

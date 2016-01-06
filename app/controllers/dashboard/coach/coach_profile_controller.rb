class Dashboard::Coach::CoachProfileController < DashboardController
  before_filter :find_coach

  def edit
  end

  def update
    @coach.update coach_params

    render :edit
  end

  private

    def find_coach
      @profile = current_user.profile
    end
end

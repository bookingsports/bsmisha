class Dashboard::CoachUsersController < DashboardController
  before_filter :find_coach, except: [ :index, :new, :create ]

  def index
    @coaches = current_user.stadium.coaches.uniq
  end

  def new
    @coach = CoachUser.new
  end

  def create
    # TODO add defence strategy if area_ids in params are of not current_user's stadium
    @coach = CoachUser.new coach_user_params
    if @coach.save(context: :stadium_dashboard)
      redirect_to dashboard_coach_users_path, notice: "Тренер успешно создан"
    else
      render :new
    end
  end

  def update
    @coach.assign_attributes coach_user_params.delete_if {|k, v| k == "password" and v.empty? }
    if @coach.save(context: :stadium_dashboard)
      redirect_to dashboard_coach_users_path, notice: "Тренер успешно сохранен"
    else
      render :edit
    end
  end

  private

    def find_coach
      @coach = CoachUser.find(params[:id]) if params[:id]
    end

    def coach_user_params
      params.require(:coach_user).permit(:name, :password, :password_confirmation, :email,
        coach_attributes: [:name, :price, :id, area_ids: [],
        coaches_areas_attributes: [:id, :area_id, :price, :_destroy]])
    end
end

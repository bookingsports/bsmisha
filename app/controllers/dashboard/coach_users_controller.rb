class Dashboard::CoachUsersController < DashboardController
  before_filter :find_coach, except: [ :index, :new, :create ]

  def index
    @coaches = current_user.stadium.coaches.uniq
  end

  def new
    @coach_user = CoachUser.new
    @coach = @coach_user.build_coach
  end

  def create
    # TODO add defence strategy if area_ids in params are of not current_user's stadium
    @coach_user = CoachUser.new coach_user_params
    @coach = @coach_user.coach.present? ? @coach_user.coach : @coach_user.build_coach
    if coach_user_params[:coach_attributes].blank?
      @coach_user.errors.add(:base, "Добавьте хотя бы 1 площадку")
      render :new
    else
      if !@coach_user.save(context: :stadium_dashboard)
        render :new
      else
        redirect_to dashboard_coach_users_path, notice: "Тренер успешно создан"
      end
    end
  end

  def update
    if coach_user_params[:coach_attributes].blank?
      @coach_user.errors.add(:base, "Добавьте хотя бы 1 площадку")
      render :edit
    else
      @coach_user.assign_attributes coach_user_params.delete_if {|k, v| k == "password" and v.empty? }
      if @coach_user.save
        redirect_to dashboard_coach_users_path, notice: "Тренер успешно создан"
      else
        render :edit
      end
    end
  end

  private

    def find_coach
      @coach_user = CoachUser.find(params[:id]) if params[:id]
      @coach = @coach_user.coach.present? ? @coach_user.coach : @coach_user.build_coach
    end

    def coach_user_params
      params.require(:coach_user).permit(:name, :password, :password_confirmation, :email,
        coach_attributes: [:name, :price, :id, area_ids: [],
        coaches_areas_attributes: [:id, :area_id, :price, :_destroy]])
    end
end

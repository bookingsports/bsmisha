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
    if coach_user_params[:coach_attributes].blank?
      @coach.errors.add(:base, "Добавьте хотя бы 1 площадку")
      render :new
    else
      ActiveRecord::Base.transaction do
        @coach.coach = nil
        @coach.save(context: :stadium_dashboard) or ((render :new) && return)
        result = @coach.coach.update(coach_user_params[:coach_attributes])
        if @coach.coach.coaches_areas.where(area: current_user.stadium.area_ids).blank?
          @coach.errors.add(:base, "Добавьте хотя бы 1 площадку")
          render :new
        elsif result
          redirect_to dashboard_coach_users_path, notice: "Тренер успешно создан"
        else
          render :new
        end
      end
    end
  end

  def update
    if coach_user_params[:coach_attributes].blank?
      @coach.errors.add(:base, "Добавьте хотя бы 1 площадку")
      render :edit
    else
      ActiveRecord::Base.transaction do
        @coach.assign_attributes coach_user_params.delete_if {|k, v| k == "password" and v.empty? }
        result = @coach.save(context: :stadium_dashboard) && @coach.coach.save && @coach.coach.coaches_areas.map(&:save)
        if @coach.coach.coaches_areas.where(area: current_user.stadium.area_ids).blank?
          @coach.errors.add(:base, "Добавьте хотя бы 1 площадку")
          render :edit
          raise ActiveRecord::Rollback
        elsif result
          redirect_to dashboard_coach_users_path, notice: "Тренер успешно создан"
        else
          render :edit
        end
      end
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

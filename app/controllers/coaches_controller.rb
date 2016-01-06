class CoachesController < ApplicationController
  before_action :set_coach, only: :show

  def index
    @q = Coach.ransack(params[:q])
    @coaches = @q.result(distinct: true)
  end

  def show
  end

  private

    def set_coach
      @coach = Coach.friendly.find params[:coach_id] || params[:id]
    end
end

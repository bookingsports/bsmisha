# == Schema Information
#
# Table name: coaches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  slug        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CoachesController < ApplicationController
  before_action :set_coach, only: :show
  respond_to :json, :html

  def index
    if params[:area_id]
      @coaches_areas = CoachesArea.where(area: Area.friendly.find(params[:area_id]))
    else
      @q = Coach.ransack(params[:q])
      @coaches = @q.result(distinct: true)
    end
  end

  def show
  end

  private

    def set_coach
      @coach = Coach.friendly.find params[:coach_id] || params[:id]
    end
end

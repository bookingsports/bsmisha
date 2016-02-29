# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer
#  email       :string
#  avatar      :string
#  opens_at    :time
#  closes_at   :time
#

class StadiumsController < ApplicationController
  before_action :set_stadium, only: [:show, :edit, :update]
  layout 'stadium', except: [:index]

  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:areas, :pictures)
                  .active

    @stadiums.where(category_id: params[:category_id]) if params[:category_id].present?

    set_markers @stadiums
  end

  def show
    set_markers [@stadium]
  end

  private

    def set_stadium
      @stadium  = Stadium.friendly.find(params[:id])
    end
end

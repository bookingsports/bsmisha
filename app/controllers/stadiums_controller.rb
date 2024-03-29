# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  name        :string           default("Без названия"), not null
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer          default(0)
#  email       :string
#  main_image  :string
#  opens_at    :time
#  closes_at   :time
#  created_at  :datetime
#  updated_at  :datetime
#

class StadiumsController < ApplicationController
  before_action :set_stadium, only: [:show, :edit, :update]
  layout 'stadium', except: [:index]

  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:areas, :category)
                  .where('areas_count > 0')
                  .active

    if params[:categories].present?
      @categories = Category.all.where(slug: params[:categories].values).map(&:id)
      @stadiums = @stadiums.where(category_id: @categories)
    elsif params[:category_id].present?
      @category = Category.friendly.find(params[:category_id])
      @stadiums = @stadiums.where(category: @category)
    end

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

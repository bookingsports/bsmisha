# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  user_id      :integer
#  name         :string
#  phone        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :string
#  latitude     :float            default(55.75)
#  longitude    :float            default(37.61)
#  slug         :string
#  status       :integer          default(0)
#  type         :string
#  parent_id    :integer
#  email        :string
#  avatar       :string
#  price        :float
#  change_price :float
#  opens_at     :time
#  closes_at    :time
#

class StadiumsController < ApplicationController
  before_action :set_stadium, only: [:show, :edit, :update]
  layout 'stadium', except: [:index]

  def index
    @q = Stadium.ransack(params[:q])

    @stadiums = @q.result(distinct: true)
                  .includes(:courts, :pictures)
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

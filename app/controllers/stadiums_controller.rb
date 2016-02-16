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
#  price        :decimal(8, 2)
#  change_price :decimal(8, 2)
#  opens_at     :datetime
#  closes_at    :datetime
#

class StadiumsController < ApplicationController
  before_action :set_stadium, only: [:show, :edit, :update]
  respond_to :html, :js, :json
  layout "stadium", except: [:index]

  def index
    @q = Stadium.ransack(params[:q])
    @stadiums = @q.result(distinct: true).active

    if params[:category_id].present?
      @category = Category.friendly.find(params[:category_id])
      @stadiums = @category.stadiums
    end

    @stadiums = @stadiums.includes(:courts, :pictures)

    respond_with @stadiums
  end

  def show
  end

  private

    def set_stadium
      @stadium  = Stadium.friendly.find(params[:id])
    end
end

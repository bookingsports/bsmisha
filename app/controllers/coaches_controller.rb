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
#  opens_at     :time
#  closes_at    :time
#

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

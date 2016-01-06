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

    respond_with @stadiums
  end

  def show
  end

  private

    def set_stadium
      @stadium  = Stadium.friendly.find(params[:id])
    end
end

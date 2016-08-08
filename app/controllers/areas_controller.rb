# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  change_price :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#

class AreasController < ApplicationController
  layout :set_layout
  before_filter :set_scope

  def index
    @stadium = Stadium.friendly.find(params[:stadium_id])
    @areas = @stadium.areas
  end

  def show
    @area = Area.friendly.find params[:id]
    set_gon_area
    gon.scope = params[:scope]
    if params[:scope] == "coach"
      gon.coach_id = @product.id
    end
  end

  def total
    if current_user.nil?
      render nothing: true
      return
    end

    @area = Area.friendly.find(params[:id])

    if params[:scope] == "stadium" && current_user.present?
      @events = current_user.events.includes(:coach, :area, :stadium_services).unconfirmed.future.where(area: @area).sort_by(&:start)
      @eventChanges = current_user.event_changes.future.unpaid.includes(:event)
    elsif params[:scope] == "coach" && current_user.present?
      @events = current_user.events.includes(:coach, :area, :stadium_services).unconfirmed.future.where(area: @area).where(coach_id: @product.id).sort_by(&:start)
    end

    @totalHours = @events.map{|e| e.duration_in_hours * e.occurrences}.inject(:+) || 0
    @total = @events.map(&:price).inject(:+) || 0

    respond_to do |format|
      format.js {}
    end
  end

  private

    def set_layout
      params[:scope] || "application"
    end

    def set_scope
      if params[:scope]
        scope = params[:scope]
        record = scope.classify.constantize.friendly.find params[scope+"_id"] || params[:id]
        instance_variable_set("@"+params[:scope], record)
        instance_variable_set("@product", record)
      end
    end
end

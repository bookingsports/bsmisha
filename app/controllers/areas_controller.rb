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
  respond_to :json, :html
  before_action :total, only: [ :show]
  before_filter :set_scope

  def index
    @stadium = Stadium.friendly.find(params[:stadium_id])
    if params[:category_id]
      @category = params[:category_id]
    else
      @category = @stadium.categories.first.id
    end
    if params[:areas]
      @areas = @stadium.areas.where(category_id: @category, id: params[:areas].values )
    else
      @areas = @stadium.areas.where(category_id: @category)
    end
    gon.stadium_slug = @stadium.slug
    gon.stadium = @stadium.id
    gon.opens_at = Time.zone.parse(@stadium.opens_at.to_s).strftime("%H:%M")
    gon.closes_at = Time.zone.parse(@stadium.closes_at.to_s).strftime("%H:%M")
    gon.current_user = current_user
    gon.areas = @areas.as_json

    respond_to do |format|
      format.html  {return @areas}
      format.json { render json: @areas }
    end
  end

  def show
    @area = Area.friendly.find params[:id]
    set_gon_area
    gon.stadium = @area.stadium.id
    gon.scope = params[:scope]
    if params[:scope] == "coach"
      gon.coach_id = @product.id
    end
  end

  def total
    if current_user.nil?
      return
    end
    @area = Area.friendly.find(params[:id])
    if params[:scope] == "stadium" && current_user.present?
      @events = current_user.events.includes(:coach, :services).unconfirmed.future.where(area: @area).sort_by(&:start)
      @group_events = current_user.recorded_group_events.future.where("event_guests.status = 0").where(area: @area)
      @eventChanges = current_user.event_changes.future.unpaid.includes(:event)
    elsif params[:scope] == "coach" && current_user.present?
      @events = current_user.events.includes(:coach, :services).unconfirmed.future.where(area: @area).where(coach_id: @product.id).sort_by(&:start)
      @eventChanges = @events.map(&:event_change)
    end

    @totalHours = @events.map{|e| e.duration_in_hours * e.occurrences}.inject(:+) || 0
    @total = @events.map(&:price).inject(:+) || 0
    @totalChanges = @eventChanges.map(&:total).inject(:+) || 0
    @recoupment = current_user.recoupments.where(area: @area) && current_user.recoupments.where(area: @area).first
    @discount = @area.discounts.where("type_user = 'all_users' OR type_user = 'only_selected' AND user_id =" + current_user.id.to_s).where("hours_count <= ?", @totalHours).order("hours_count ASC, value DESC").first
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

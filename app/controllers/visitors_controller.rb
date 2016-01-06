class VisitorsController < ApplicationController
  def index
    @stadiums = Stadium.where("status <> ?", Stadium.statuses[:pending])
  end
end

class VisitorsController < ApplicationController
  def index
    @stadiums = Stadium.without_status(:pending)
  end
end

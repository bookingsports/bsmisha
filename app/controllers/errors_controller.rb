class ErrorsController < ApplicationController

  def not_found
    render :file => "errors/not_found.html.erb", :status => 404
  end

end

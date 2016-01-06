class Dashboard::Stadium::StadiumsController < DashboardController
  before_filter :find_stadium

  def edit
  end

  def update
    @stadium.update stadium_params

    render :edit
  end

  private

    def find_stadium
      @stadium = current_user.stadium
    end

    def stadium_params
      params.require(:stadium).permit(:name, :address, :telephone, :description, :category_id, :phone, :latitude, :longitude,
        courts_attributes: [:id, :name, :price, :change_price, :_destroy])
    end
end

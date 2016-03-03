class Dashboard::PricesController < DashboardController
  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # GET /dashboard/prices
  # GET /dashboard/prices.json
  def index
    @prices = current_user.prices
  end

  # GET /dashboard/prices/1
  # GET /dashboard/prices/1.json
  def show
  end

  # GET /dashboard/prices/new
  def new
    @price = Price.new
    @price.daily_price_rules.new
  end

  # GET /dashboard/prices/1/edit
  def edit
  end

  # POST /dashboard/prices
  # POST /dashboard/prices.json
  def create
    @price = Price.new(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to dashboard_prices_path(@product), notice: 'Период создан.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboard/prices/1
  # PATCH/PUT /dashboard/prices/1.json
  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to dashboard_prices_path, notice: 'Период обновлен.' }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboard/prices/1
  # DELETE /dashboard/prices/1.json
  def destroy
    @price.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_prices_url, notice: 'Период успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = current_user.prices.select {|p| p.id.to_s == params[:id]}.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:start, :stop, :price, :product_id, :is_sale, :area_id, daily_price_rules_attributes: [:id, :start, :stop, :_destroy, :price, working_days: []])
    end
end

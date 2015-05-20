class Dashboard::PaymentsController < DashboardController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def success
    @request = DepositRequest.find(params['OrderId'])

    @response = @request.deposit_responses.create data: params
    if @response.response_data.security_key == params["SecurityKey"]
      @request.status = :success
      @request.save 
      # redirect_to dashboard_deposit_requests_path, notice: 'Кошелек успешно пополнен'
    else
      @request.status = :failure
      @request.save
      # redirect_to dashboard_deposit_requests_paths
    end
    
    render text: 'OK', status: 200
  end
end
class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def success
    @request = DepositRequest.find(params["OrderId"])

    @response = @request.deposit_responses.create(data: params.to_json)

    if @response.response_data.security_key == params["SecurityKey"]
      @request.status = :success
      @request.save
    else
      @request.status = :failure
      @request.save
    end

    render text: 'OK', status: 200
  end
end

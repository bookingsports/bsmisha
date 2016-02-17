class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :set_request_and_response

  def success
    if @response.response_data.security_key == params["SecurityKey"]
      @request.status = :success
      @request.save
    else
      @request.status = :failure
      @request.save
    end

    render text: 'OK', status: 200
  end

  def failure
    @request.status = :failure
    @request.save

    render text: 'OK', status: 200
  end

  private

  def set_request_and_response
    @request = DepositRequest.find_by(uuid: params["OrderId"])
    @response = @request.deposit_responses.create(data: params.to_json)
  end
end

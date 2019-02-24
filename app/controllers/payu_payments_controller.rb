class PayuPaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notification
      if request.get?
        render text: true
      else
        current_time = Time.now.strftime('%Y%m%d%H%M%S')
        checksum = SignatureService.new(ipn_response_data(current_time)).checksum
        render plain: "<epayment>#{current_time}|#{checksum}</epayment>"
      end
    end

  private

  def ipn_response_data(current_time)
    {
        ipn_pid: params[:IPN_PID][0],
        ipn_pname: params[:IPN_PNAME][0],
        ipn_date: params[:IPN_DATE],
        current_time: current_time
    }
  end
end
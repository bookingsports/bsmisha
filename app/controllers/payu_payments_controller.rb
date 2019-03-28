class PayuPaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notification
      if request.get?
        render text: true
      else
        event = Event.find(params[:REFNOEXT])
        puts event.status
        puts params
        if event.present?
          if params[:ORDERSTATUS] == "PAYMENT_AUTHORIZED"
            puts "in auth"
            event.update status: :confirmed
          elsif params[:ORDERSTATUS] == "COMPLETE"
            event.update status: :paid
          elsif params[:ORDERSTATUS] == "REVERSED" || params[:orderstatus] == "REFUND"
            event.update status: :canceled
          end
        end
        puts event.status
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

  def pp_params
    params.require(:payu_payments).permit(:amount, :payment_method)
  end
end
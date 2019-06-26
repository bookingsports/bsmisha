class PayuPaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notification
      if request.get?
        render text: true
      else
        order = Order.find(params[:REFNOEXT])
        current_time = Time.now.strftime('%Y%m%d%H%M%S')
        checksum = SignatureService.new(ipn_response_data(current_time)).checksum
        render plain: "<epayment>#{current_time}|#{checksum}</epayment>"
        if order.present?
          if params[:ORDERSTATUS] == "PAYMENT_AUTHORIZED"
            order.update_status(:paid)
          elsif params[:ORDERSTATUS] == "COMPLETE"
            order.update status: :paid_approved
            CashierChecks.new(order,"SaleReceiptRequest").send_request
          elsif params[:ORDERSTATUS] == "REVERSED" || params[:orderstatus] == "REFUND"
            order.update status: :canceled
          end
        end
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
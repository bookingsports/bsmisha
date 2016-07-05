class DepositRequestObserver < ActiveRecord::Observer
  def after_update request
    if request.success?
      DepositRequestMailer.payment_succeeded(request).deliver_now
    end
  end
end
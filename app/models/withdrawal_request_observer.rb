class WithdrawalRequestObserver < ActiveRecord::Observer
  def after_update request
    if request.success?
      WithdrawalRequestMailer.withdrawal_succeeded(request).deliver_now
    elsif request.failure?
      WithdrawalRequestMailer.withdrawal_failed(request).deliver_now
    end
  end
end
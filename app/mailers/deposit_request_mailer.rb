class DepositRequestMailer < ApplicationMailer
  def payment_succeeded request
    @request = request
    mail(to: @request.wallet.user.email, subject: "⚽️ Bookingsports: Баланс пополнен")
  end
end

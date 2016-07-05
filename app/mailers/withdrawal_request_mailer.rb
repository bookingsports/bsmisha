class WithdrawalRequestMailer < ApplicationMailer
  def withdrawal_succeeded request
    @request = request
    mail(to: @request.wallet.user.email, subject: "⚽️ Bookingsports: Успешный вывод средств")
  end

  def withdrawal_failed request
    @request = request
    mail(to: @request.wallet.user.email, subject: "⚽️ Bookingsports: Запрос на вывод средств отклонен")
  end
end


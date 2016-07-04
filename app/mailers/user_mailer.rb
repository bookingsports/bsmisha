class UserMailer < ApplicationMailer
  def registration_mail(user)
    @user = user
    mail(to: user.email, subject: "⚽️ Bookingsports: Регистрация пользователя")
  end
end

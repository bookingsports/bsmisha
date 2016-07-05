class UserMailer < ApplicationMailer
  def registration_mail(user)
    @user = user
    mail(to: user.email, subject: "Вы зарегестрировались на сайте⚽️ Bookingsports")
  end
end

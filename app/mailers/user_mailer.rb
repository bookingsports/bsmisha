class UserMailer < Devise::Mailer
  default from: "support@bookingsports.ru"
  layout "mailer"
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def registration_mail(user)
    @user = user
    mail(to: user.email, subject: "Вы зарегистрировались на сайте⚽️ Bookingsports")
  end

  def reset_password_instructions(record, token, opts={})
    super
  end
end

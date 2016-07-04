class UserObserver < ActiveRecord::Observer
  def after_create user
    UserMailer.registration_mail(user).deliver_now
  end
end
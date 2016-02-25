class FeedbackMailer < ApplicationMailer
  def simple feedback_params
    @feedback_params = feedback_params
    mail(to: 'info@bookingsports.ru', subject: "⚽️ Bookingsports: Обратная связь")
  end
end

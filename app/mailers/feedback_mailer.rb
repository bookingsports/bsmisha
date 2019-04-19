class FeedbackMailer < ApplicationMailer
  def simple feedback_params
    @feedback_params = feedback_params
    mail(to: 'support@bookingsports.ru', subject: "⚽️ Bookingsports: Обратная связь")
  end
end

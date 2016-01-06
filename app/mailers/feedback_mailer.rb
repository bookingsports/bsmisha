class FeedbackMailer < ApplicationMailer
  def simple feedback_params
    @feedback_params = feedback_params
    mail(to: Option.current.feedback_email, subject: "⚽️ Bookingsports: Обратная связь")
  end
end

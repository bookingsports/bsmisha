class RecoupmentMailer < ApplicationMailer
  def recoupment_changed rec
    @old_price = rec.price_was || 0
    @rec = rec
    if rec.price - @old_price > 0
      mail(to: @rec.user.email, subject: "⚽️ Bookingsports: Вам начислены отыгрыши")
    end
  end
end

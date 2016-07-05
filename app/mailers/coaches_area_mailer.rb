class CoachesAreaMailer < ApplicationMailer
  def coaches_area_created ca
    @ca = ca
    mail(to: @ca.area.stadium.user.email, subject: "⚽️ Bookingsports: Запрос тренера на привязку к стадиону")
  end

  def coaches_area_destroyed ca
    @ca = ca
    mail(to: @ca.area.stadium.user.email, subject: "⚽️ Привязка тренера к стадиону удалена тренером")
  end

  def coaches_area_confirmed ca
    @ca = ca
    mail(to: @ca.coach.user.email, subject: "⚽️ Привязка тренера к стадиону подтверждена")
  end

  def coaches_area_locked ca
    @ca = ca
    mail(to: @ca.coach.user.email, subject: "⚽️ Привязка тренера к стадиону заблокирована")
  end

  def coaches_area_unlocked ca
    @ca = ca
    mail(to: @ca.coach.user.email, subject: "⚽️ Привязка тренера к стадиону разблокирована")
  end

  def area_destroyed_notify_coach ca
    @ca = ca
    mail(to: @ca.coach.user.email, subject: "⚽️ Площадка, к которой вы привязаны, была удалена")
  end
end

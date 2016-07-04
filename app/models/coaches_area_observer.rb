class CoachesAreaObserver < ActiveRecord::Observer
  def after_create ca
    CoachesAreaMailer.coaches_area_created(ca).deliver_now
  end

  def after_update ca
    if ca.status_was == "active" && ca.locked?
      CoachesAreaMailer.coaches_area_locked(ca).deliver_now
    elsif ca.status_was == "locked" && ca.active?
      CoachesAreaMailer.coaches_area_unlocked(ca).deliver_now
    elsif ca.status_was == "pending" && ca.active?
      CoachesAreaMailer.coaches_area_confirmed(ca).deliver_now
    end
  end

  def after_destroy ca
    CoachesAreaMailer.coaches_area_destroyed(ca).deliver_now
  end
end

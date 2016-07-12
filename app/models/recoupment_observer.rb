class RecoupmentObserver < ActiveRecord::Observer
  def after_save rec
    RecoupmentMailer.recoupment_changed(rec).deliver_now
  end
end
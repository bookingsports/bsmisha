class MailController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def coaches_area_confirmed
    @ca = CoachesArea.find(params[:id])
    if current_user == @ca.coach.user
      render 'coaches_area_mailer/coaches_area_confirmed'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def coaches_area_created
    @ca = CoachesArea.find(params[:id])
    if current_user == @ca.area.stadium.user
      render 'coaches_area_mailer/coaches_area_created'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def coaches_area_locked
    @ca = CoachesArea.find(params[:id])
    if current_user == @ca.coach.user
      render 'coaches_area_mailer/coaches_area_locked'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def coaches_area_unlocked
    @ca = CoachesArea.find(params[:id])
    if current_user == @ca.coach.user
      render 'coaches_area_mailer/coaches_area_unlocked'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_changed
    @event = Event.find(params[:id])
    if current_user == @event.user
      render 'event_mailer/date_change_mail'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_changed_notify_coach
    @event = Event.find(params[:id])
    if current_user == @event.coach.user
      render 'event_mailer/event_changed_notify_coach'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_changed_notify_stadium
    @event = Event.find(params[:id])
    if current_user == @event.area.stadium.user
      render 'event_mailer/event_changed_notify_stadium'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_buying
    @event = Event.find(params[:id])
    if current_user == @event.user
      render 'event_mailer/event_buying_mail'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_confirmed
    @event = Event.find(params[:id])
    if current_user == @event.user
      render 'event_mailer/event_confirmed'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_confirmed_notify_coach
    @event = Event.find(params[:id])
    if current_user == @event.coach.user
      render 'event_mailer/event_confirmed_notify_coach'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_confirmed_notify_stadium
    @event = Event.find(params[:id])
    if current_user == @event.area.stadium.user
      render 'event_mailer/event_confirmed_notify_stadium'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_sold_notify_coach
    @event = Event.find(params[:id])
    if current_user == @event.coach.user
      render 'event_mailer/event_sold_notify_coach'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_paid
    @event = Event.find(params[:id])
    if current_user == @event.user
      render 'event_mailer/event_paid'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_paid_notify_coach
    @event = Event.find(params[:id])
    if current_user == @event.coach.user
      render 'event_mailer/event_paid_notify_coach'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def event_paid_notify_stadium
    @event = Event.find(params[:id])
    if current_user == @event.area.stadium.user
      render 'event_mailer/event_paid_notify_stadium'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def deposit_payment_succeeded
    @request = DepositRequest.find(params[:id])
    if current_user == @request.wallet.user
      render 'deposit_request_mailer/payment_succeeded'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def withdrawal_succeeded
    @request = WithdrawalRequest.find(params[:id])
    if current_user == @request.wallet.user
      render 'withdrawal_request_mailer/withdrawal_succeeded'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end

  def withdrawal_failed
    @request = WithdrawalRequest.find(params[:id])
    if current_user == @request.wallet.user
      render 'withdrawal_request_mailer/withdrawal_failed'
    else
      redirect_to root_url, alert: "Вы не можете просмотреть данное письмо."
    end
  end
end

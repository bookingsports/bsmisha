Rails.application.routes.draw do
  authenticate :user do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  get 'grid/(:area_id)/coaches.json', to: 'coaches#index'
  get 'grid/(:area_id)/events.json', to: 'events#index'
  post 'grid/(:area_id)/events', to: 'events#create'
  get 'grid/events.json', to: 'events#index'
  delete 'grid/(:area_id)/events/(:id)', to: 'events#destroy'
  delete 'grid/events/(:id)', to: 'events#destroy'
  get 'products/show'
  get 'grid/(:area_id)', to: 'dashboard#grid', as: 'dashboard_grid'

  get 'mail/user_registration/(:id)', to: "mail#user_registration", as: "user_registration_mail"
  get 'mail/coaches_area_confirmed/(:id)', to: "mail#coaches_area_confirmed", as: "coaches_area_confirmed_mail"
  get 'mail/coaches_area_created/(:id)', to: "mail#coaches_area_created", as: "coaches_area_created_mail"
  get 'mail/coaches_area_locked/(:id)', to: "mail#coaches_area_locked", as: "coaches_area_locked_mail"
  get 'mail/coaches_area_unlocked/(:id)', to: "mail#coaches_area_unlocked", as: "coaches_area_unlocked_mail"
  get 'mail/event_changed/(:id)', to: "mail#event_changed", as: "event_changed_mail"
  get 'mail/event_changed_notify_coach/(:id)', to: "mail#event_changed_notify_coach", as: "event_changed_notify_coach_mail"
  get 'mail/event_changed_notify_stadium/(:id)', to: "mail#event_changed_notify_stadium", as: "event_changed_notify_stadium_mail"
  get 'mail/event_confirmed/(:id)', to: "mail#event_confirmed", as: "event_confirmed_mail"
  get 'mail/event_confirmed_notify_coach/(:id)', to: "mail#event_confirmed_notify_coach", as: "event_confirmed_notify_coach_mail"
  get 'mail/event_confirmed_notify_stadium/(:id)', to: "mail#event_confirmed_notify_stadium", as: "event_confirmed_notify_stadium_mail"
  get 'mail/event_buying/(:id)', to: "mail#event_buying", as: "event_buying_mail"
  get 'mail/event_sold_notify_coach/(:id)', to: "mail#event_sold_notify_coach", as: "event_sold_notify_coach_mail"
  get 'mail/event_paid/(:id)', to: "mail#event_paid", as: "event_paid_mail"
  get 'mail/event_paid_notify_coach/(:id)', to: "mail#event_paid_notify_coach", as: "event_paid_notify_coach_mail"
  get 'mail/event_paid_notify_stadium/(:id)', to: "mail#event_paid_notify_stadium", as: "event_paid_notify_stadium_mail"
  get 'mail/deposit_payment_succeeded/(:id)', to: "mail#deposit_payment_succeeded", as: "deposit_payment_succeeded_mail"
  get 'mail/withdrawal_succeeded/(:id)', to: "mail#withdrawal_succeeded", as: "withdrawal_succeeded_mail"
  get 'mail/withdrawal_failed/(:id)', to: "mail#withdrawal_failed", as: "withdrawal_failed_mail"

  concern :bookable do
    resources :events
    resources :my_events
    collection do
      get 'events', to: 'events#index'
    end
  end
  concern :totalable do
    member do
      get 'total'
    end
  end

  concern :has_pictures do
    resources :pictures
  end

  concern :has_prices do
    resources :prices
  end

  resources :events, :my_events do
    collection do
      get 'paid'
      get 'grid'
      post 'bulk_process', constraints: ButtonParamRouting.new('pay'), action: 'confirm_pay', controller: 'my_events'
      post 'bulk_process', constraints: ButtonParamRouting.new('destroy'), action: 'destroy'
      post 'bulk_process', constraints: ButtonParamRouting.new('confirm'), action: 'confirm'
      post 'pay'
      get 'one_day'
      get 'for_sale'
      post 'confirm_pay'
    end
    member do
      post 'pay_change'
      post 'overpay'
      post 'sell'
      post 'buy'
      get 'ticket'
    end
  end

  resources :products, concerns: :bookable

  # scope :my do
    # resources :areas
  # end

  post 'feedback/create', as: 'feedback'

  resources :static_pages, only: :show

  namespace :admin do
    resources :users
  end
  # resources :changes, only: :create

  post 'payments/process_order'
  post 'payments/check_order'
  post 'payments/success'
  post 'payments/failure'

  namespace :dashboard do
    post 'product', to: "products#update"
    resource :product, concerns: [:has_pictures], except: [:create] do
      get 'edit_account', on: :member
      get 'edit_recoupments', on: :member
      get 'edit_discounts', on: :member
    end
    resources :area do
      resources :prices
    end
    resources :customers
    resources :employments
    resources :coach_users do
      member do
        get 'confirm'
      end
    end
    resources :withdrawal_requests do
      get :print, on: :member
    end
  end

  resources :deposit_requests do
    member do
      get 'pay'
    end
  end

  constraints RoleRouteConstraint.new('admin') do
    namespace :dashboard do
      scope module: :customer do
        resources :orders do
          member do
            patch 'pay'
          end
        end
      end
    end
  end

  resources :areas, concerns: [:bookable, :totalable]

  resources :coaches, defaults: { scope: 'coach' } do
    resources :areas, concerns: [:bookable, :totalable]
  end

  resources :stadiums, defaults: { scope: 'stadium' } do
    resources :events
    resources :pictures, only: :index
    resources :reviews
    resources :areas, concerns: [:bookable, :totalable] do
      resources :coaches, only: :index
    end
  end

  resources :stadium_users

  get 'categories/:category_id', to: 'stadiums#index', as: 'category'

  root to: 'visitors#index'
  devise_for :users, controllers: {registrations: "users/registrations"}

  get 'switch_user' => 'switch_user#set_current_user'

  # unless Rails.application.config.consider_all_requests_local
  get '*not_found', to: 'errors#not_found'
  # end
end

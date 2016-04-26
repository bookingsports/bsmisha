Rails.application.routes.draw do
  authenticate :user do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  get 'grid/(:area_id)/coaches.json', to: 'coaches#index'
  get 'grid/(:area_id)/events.json', to: 'events#index'
  get 'grid/events.json', to: 'events#index'
  delete 'grid/(:area_id)/events/(:id)', to: 'events#destroy'
  delete 'grid/events/(:id)', to: 'events#destroy'
  get 'products/show'
  get 'grid/(:area_id)', to: 'dashboard#grid', as: 'dashboard_grid'

  concern :bookable do
    resources :events
    resources :my_events
    collection do
      get 'events', to: 'events#parents_events'
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
      post 'bulk_process', constraints: ButtonParamRouting.new('pay'), action: 'create', controller: 'orders'
      post 'bulk_process', constraints: ButtonParamRouting.new('destroy'), action: 'destroy'
      post 'bulk_process', constraints: ButtonParamRouting.new('confirm'), action: 'confirm'
    end
    member do
      get 'ticket'
      post 'pay_change'
      post 'overpay'
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

  resources :orders do
    member do
      patch 'pay'
    end
  end

  namespace :dashboard do
    post 'product', to: "products#update"
    resource :product, concerns: [:has_pictures], except: [:create] do
      get 'edit_account', on: :member
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
  devise_for :users
end

Rails.application.routes.draw do
  authenticate :user do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  get 'grid/(:area_id)', to: 'dashboard#grid', as: 'dashboard_grid'
  get 'products/show'

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

  post 'payments/success'
  post 'payments/failure'

  resources :orders do
    member do
      patch 'pay'
    end
  end

  namespace :dashboard do
    resource :product, concerns: [:has_pictures] do
      get 'edit_account', on: :member
    end
    resources :prices
    resources :customers
    resources :employments
    resources :coach_users
    resources :withdrawal_requests do
      get :print, on: :member
    end
  end

  resources :deposit_requests

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
    resources :areas, concerns: [:bookable, :totalable]
  end

  resources :stadium_users

  get 'categories/:category_id', to: 'stadiums#index', as: 'category'

  root to: 'visitors#index'
  devise_for :users
end

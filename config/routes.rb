Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/most_revenue', to: 'most_revenue#index'
        get '/:id/favorite_customer', to: 'favorite_customer#show'
        get '/revenue', to: 'revenue#show'
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end

      namespace :invoices do
        get '/:invoice_id/transactions', to: 'transactions#index'
      end

      resources :invoices, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end

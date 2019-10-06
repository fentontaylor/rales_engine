Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/most_revenue', to: 'most_revenue#index'
        get '/:id/favorite_customer', to: 'favorite_customer#show'
        get '/revenue', to: 'revenue#show'
        get '/:merchant_id/items', to: 'items#index'
        get '/:merchant_id/invoices', to: 'invoices#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      resources :merchants, only: [:index, :show]

      namespace :invoices do
        get '/:invoice_id/transactions', to: 'transactions#index'
        get '/:invoice_id/invoice_items', to: 'invoice_items#index'
        get '/:invoice_id/items', to: 'items#index'
        get '/:invoice_id/customer', to: 'customer#show'
        get '/:invoice_id/merchant', to: 'merchant#show'
      end

      resources :invoices, only: [:index, :show]

      namespace :items do
        get '/most_revenue', to: 'most_revenue#index'
        get '/:id/best_day', to: 'best_day#show'
      end
      resources :items, only: [:index, :show]

      namespace :invoice_items do
        get '/:id/invoice', to: 'invoice#show'
        get '/:id/item', to: 'item#show'
      end

      resources :invoice_items, only: [:index, :show]

      namespace :customers do
        get '/:id/favorite_merchant', to: 'favorite_merchant#show'
        get '/:id/invoices', to: 'invoices#index'
      end

      resources :customers, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end

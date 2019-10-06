Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/:id/favorite_customer', to: 'favorite_customer#show'
        get '/:id/items', to: 'items#index'
        get '/:id/invoices', to: 'invoices#index'
        get '/revenue', to: 'revenue#show'
        get '/most_revenue', to: 'most_revenue#index'
        get '/random', to: 'random#show'
      end

      resources :merchants, only: [:index, :show]

      namespace :invoices do
        get '/find', to: 'search#show'
        get '/:invoice_id/transactions', to: 'transactions#index'
        get '/:invoice_id/invoice_items', to: 'invoice_items#index'
        get '/:invoice_id/items', to: 'items#index'
        get '/:invoice_id/customer', to: 'customer#show'
        get '/:invoice_id/merchant', to: 'merchant#show'
        get '/random', to: 'random#show'
      end

      resources :invoices, only: [:index, :show]

      namespace :items do
        get '/most_revenue', to: 'most_revenue#index'
        get '/:id/best_day', to: 'best_day#show'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/merchant', to: 'merchant#show'
        get '/random', to: 'random#show'
      end
      resources :items, only: [:index, :show]

      namespace :invoice_items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/:id/invoice', to: 'invoice#show'
        get '/:id/item', to: 'item#show'
        get '/random', to: 'random#show'
      end

      resources :invoice_items, only: [:index, :show]

      namespace :customers do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/:id/favorite_merchant', to: 'favorite_merchant#show'
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/transactions', to: 'transactions#index'
        get '/random', to: 'random#show'
      end

      resources :customers, only: [:index, :show]

      namespace :transactions do
        get '/:id/invoice', to: 'invoice#show'
        get '/random', to: 'random#show'
      end
      resources :transactions, only: [:index, :show]
    end
  end
end

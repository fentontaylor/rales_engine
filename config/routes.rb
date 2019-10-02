Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end

      resources :items, only: [:index, :show]

      resources :invoices, only: [:index, :show]

      resources :invoice_items, only: [:index, :show]

      resources :customers, only: [:index, :show]

      resources :transactions, only: [:index, :show]

    end
  end
end

Rails.application.routes.draw do
  resources :products do 
    collection do 
      get 'search', to: 'products#search'
      get 'approval-queue', to: 'products#approval_queue_index'
      put 'approval-queue/:id/approve', to: 'products#approve_product'
      put 'approval-queue/:id/reject ', to: 'products#reject_product'
    end
  end
end

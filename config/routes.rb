Rails.application.routes.draw do

  root              'static_pages#home'

  get  'help',  to: 'static_pages#help'

  get  'about', to: 'static_pages#about'

  devise_for :users

  resources :pdf_templates

  resources :organizations do
    resources :members
  end

  resources :members, only: [:index]

  resources :groups do
    resources :members, only: [:index], controller: 'groups/members' do
      member do
        get 'add'
        get 'remove'
      end
    end
    resources :events do
      member { post 'print', defaults: { format: 'pdf' } }
    end
  end

  resources :events do
    resources :registrations, 
              only: [:index, :destroy], 
              controller: 'events/registrations' do
      member { get 'confirm' } 
    end

    member { get 'register', to: 'events/registrations#register' }
  end

  get "angular_test", to: "angular_test#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

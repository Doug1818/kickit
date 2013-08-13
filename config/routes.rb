Kickit::Application.routes.draw do
  
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, controllers: { registrations: "user_registrations" }
  #devise_scope :user do
  #  root to: "devise/registrations#new"
  #end
  resources :users do
    member do
      get :setup, :billing
      put :do_setup, :add_billing_info
    end
  end
  resources :programs do
    member do
      get :extend_program
      put :extend
    end
  end
  resources :text_messages do
    collection do
      post :send, :receive
    end
  end
  resources :days do
    member do
      put :success, :failure, :free, :want, :did, :want_down, :did_down
    end
  end
  resources :weeks
  resources :sent_texts
  resources :received_texts
  resources :reminders
  resources :remessages
  resources :supmessages
  resources :leads
  resources :supporters
  resources :user_todos do
    member do
      put :complete
    end
  end
  resources :comments
  
  root to: 'static_pages#home'
  match '/carousel',  to: 'static_pages#carousel'
  match '/calendar',  to: 'static_pages#calendar'
  match '/signedup',  to: 'static_pages#signedup'
  match '/checklist',  to: 'static_pages#checklist'
  match '/nbtricks',  to: 'static_pages#nbtricks'
  match '/estricks',  to: 'static_pages#estricks'
  match '/lnstricks',  to: 'static_pages#lnstricks'
  match '/oetricks',  to: 'static_pages#oetricks'
  match '/update_programs',  to: 'custom_admin_pages#update_programs'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

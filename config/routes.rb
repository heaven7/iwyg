Iwyg::Application.routes.draw do

  root :to => "page#index"
  
  filter :locale
  
  resources :meetups
  
  resources :events
  
  resources :userdetails

  resources :mailbox

  resources :locations

  resources :searches
  
    
  resources :pages                                                 
  match "/profile/:login" => 'users#show', :login => :login, :as => :profile
  
  resources :item_attatchments 

  resources :images
  
  resources :transfer_options
  
  resources :sent


  resources :friendships do
    member do
      put 'accept' 
    end
  end
  
  
  devise_for :users  do  
      get "login", :to => "devise/sessions#new" 
      get "logout", :to => "devise/sessions#destroy"
      get "signup", :to => "devise/registrations#new"
  end  

  
  resources :users do
     resources :items, :transfers, :images, :pings, :accounts, :comments, :friendships, :events, :rates, :messages, :meetups
     resource :location
     resource :userdetails
     member do
       post 'rate'
     end
     collection do
       get 'aim_suggestions'
     end
  end 
  
  
  resources :messages do
   member do
    get 'reply'
    put 'undelete'
   end
  end
  
  
  resources :message_copies do
    member do 
      put 'undelete'
    end
  end
  

  resources :pings do 
   resources :comments
   member do
    put 'accept' 
    put 'decline'
   end
  end
  
  resources :items do
   resources :images, :pings, :comments, :transfers, :item_attatchments, :events
   resource :location
   member do
    post 'rate'
   end
   collection do
    get 'tag_suggestions' 
   end
  end

  resources :transfers do
    resources :pings, :comments
    member do
      put 'accept'
      put 'decline' 
    end
  end

  match 'page/about', :to => 'page#about'                                      
  match 'page/help', :to => 'page#help'
  
  match 'signup', :to => 'devise/session#new'
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
end

Iwyg::Application.routes.draw do

  resources :user_preferences
  
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"
  resources :translations

  root :to => "page#index"
  
  filter :locale
  
  resources :meetups do
    resources :users
  end

  resources :meetings do
    member do
      put 'accept'
    end
  end
  
  resources :events

  resources :userdetails

  resources :mailbox

  resources :locations do 
    collection do
      match 'search' => 'locations#search', :via => [:get, :post], :as => :search
    end

	end

  resources :searches
      
  resources :pages                                                 
  
  resources :item_attatchments 

  resources :images
 
  resources :groupings do
    member do
      get 'accept' 
      put 'accept' 
    end
  end
 	
	devise_for :users
	
  devise_scope :user do
    get "/logout" => "devise/sessions#destroy"
    get "/login", :to => "devise/sessions#new"
    get "/signup", :to => "devise/registrations#new"
  end
  
  resources :users do
    resources :items, :pings, :groups, :images, :accounts, :comments, :friendships, :events, :messages, :meetups

		resources :invitations do
			match 'contacts', :via => [:get, :post]
		end
    resource :userdetails
    member do
      post 'rate'
      put 'follow'
      put 'block'
      put 'unblock'
      get 'followings'
      get 'followers'
    end
    collection do
      get 'aim_suggestions'
      match 'search' => 'users#search', :via => [:get, :post], :as => :search
    end
  end 
  
  resources :groups do
    resources :users, :images, :items
    member do
      put 'follow'
    end
    collection do
      get 'tag_suggestions'
      match 'search' => 'groups#search', :via => [:get, :post], :as => :search
    end
  end

  resources :sent

  resources :messages do
    member do
      put 'reply'
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
      put 'follow'
    end
    collection do
      get 'tag_suggestions'
      match 'search' => 'items#search', :via => [:get, :post], :as => :search
    end
  end

  # Transfers will not longer be used

  # resources :transfers do
  #  resources :pings, :comments
  #  member do
  #    put 'accept'
  #    put 'decline'
  #  end
  # end

  # resources :transfer_options

  match 'page/about', :to => 'page#about'                                      
  match 'page/help', :to => 'page#help'

  #  match "/profile/:login" => 'users#show', :login => :login, :as => :profile
  # match 'signup', :to => 'devise/session#new'
    
end

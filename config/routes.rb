Chilivote::Application.routes.draw do
  


  get 'auth/:provider/callback', to: 'sessions#create_from_fb'
  get 'auth/failure', to: redirect('/')
  
  resources :categories do
    collection do
      get :list_categories
    end
  end
  
  resources :search do
    collection do
      get :index
    end
  end

  resources :posts do
    collection do
      get :view_posts
      get :next
      get :previous
      get :activate
      get :deactivate
      get :list_voters
    end
  end

  get 'users/clear_notifications' => 'users#clear_notifications'
  get 'users/search' => 'users#search'
  get 'users/create_comment' => 'users#create_comment'
  post 'users/create_comment' => 'users#create_comment'
  post 'users/create_status' => 'users#create_status'
  get 'users/create_status' => 'users#create_status'
  get 'users/list_voters' => 'users#list_voters'
  get 'users/best_friends' => 'users#best_friends'
  get 'users/toggle_privacy' => 'users#toggle_privacy'
  get 'users/add_photo_to_status' => 'users#add_photo_to_status'
  get 'users/show_friend_requests' => 'users#show_friend_requests'
  get 'users/advanced_data' => 'users#advanced_data'
  get 'users/show_profile/:id' => 'users#show_profile'
  get 'users/show_public' => 'users#show_public'
  get 'svotes/vote_status_up' => 'svotes#vote_status_up'
  get 'svotes/vote_status_down' => 'svotes#vote_status_down'
  get 'users/show_notifications' => 'users#show_notifications'
  get 'users/show_options_bubble' => 'users#show_options_bubble'
  get 'users/suggestions' => 'users#suggestions'
  get 'users/followers_following' => 'users#followers_following'
  get 'users/public_notifications' => 'users#public_notifications'

  
   resources :svotes do
    collection do
      get :vote_status_up
      get :vote_status_down
      get :list_voters
    end
  end


  resources :users do
    get :vote
    get :add_avatar
    get :list_friends
    get :clear_notifications
    get :search
    get :create_comment
    get :list_voters
    get :best_friends
    post :create_status
    get :activity
    get :toggle_privacy
    get :add_photo_to_status
    get :suggestions
    get :followers_following
    get :public_notifications
    get :show_profile
  end
  
  resources :friendship do
    post :create
    post :unfriend
    post :accept
    post :decline
    get :follow_user
    get :unfollow_user
  end
  
  resources :cvote do
    collection do
      get :manage_answers
      get :start_over
      get :submit_cvote
      get :remove_cvote
      get :remove_comment
    end
  end
  
  resources :welcome do
    collection do
      get :about
      get :news
      get :help
      get :contact
      post :about
      get :from_fb
      post :from_fb
      get :request_invitation
      get :forgot_password
      get :reset_password
    end
  end
  
  resources :polls do
    collection do
      get :show_answers
      get :hide_answers
    end
  end
  resources :pvotes, only: [:create]

  
  #resources :votes, only: [:create, :destroy]
  resources :votes do
    collection do
      get :vote_status_up
      get :vote_status_down
      get :vote_on_cvote
    end 
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :cvotes
  
  resources :conversations, only: [:index, :show, :destroy]  do
    member do
      post :reply
    end
    member do
      post :restore
    end
    collection do
      delete :empty_trash
    end
  end
    
  resources :messages, only: [:new, :create]
  
  resources :favorites do
    collection do  
      get :add_to_favorites
      get :remove_from_favorites
    end
  end
  
  resources :contributions, only: [:destroy] do
    member do
      get :report_contribution
    end
  end
  
  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

 

  match '/signup', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/friends', to: 'users#list_friends', via: 'get'
  
   # You can have the root of your site routed with "root"
  #root 'categories#list_categories'
  #root 'users#new'
  root 'welcome#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  
  get 'posts/view_posts/:id' => 'posts#view_posts'
  get 'users/add_avatar/:id' => 'users#add_avatar'
  post 'friendship/create/:id' => 'friendship#create'
  post 'friendship/unfriend/:id' => 'friendship#unfriend'
  post 'friendship/accept/:id' => 'friendship#accept'
  post 'friendship/decline/:id' => 'friendship#decline'
  get 'friendship/follow_user/:id' => 'friendship#follow_user'
  get 'friendship/unfollow_user/:id' => 'friendship#unfollow_user'
  get 'cvote/manage_answers/:image_id' => 'cvote#manage_answers'
  get 'users/search/:q' => 'users#search'

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

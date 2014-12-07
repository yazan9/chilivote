Chilivote::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create_from_fb'
  get 'auth/failure', to: redirect('/')
  
  resources :categories do
    collection do
      get :list_categories
    end
  end

  resources :posts do
    collection do
      get :view_posts
      get :next
      get :previous
      get :activate
      get :deactivate
    end
  end

  get 'users/clear_notifications' => 'users#clear_notifications'
  get 'users/search' => 'users#search'

  resources :users do
    get :vote
    get :add_avatar
    get :list_friends
    get :clear_notifications
    get :search
  end
  
  resources :friendship do
    post :create
    post :unfriend
    post :accept
    post :decline
  end
  
  resources :cvote do
    collection do
      get :manage_answers
      get :start_over
      get :submit_cvote
      get :remove_cvote
    end
  end
  
  resources :welcome do
    collection do
      get :about
      get :news
      get :help
      get :contact
    end
  end
  
  resources :votes, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :cvotes
  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

 

  match '/signup', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/friends', to: 'users#list_friends', via: 'get'
  
   # You can have the root of your site routed with "root"
  #root 'categories#list_categories'
  root 'users#new'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  
  get 'posts/view_posts/:id' => 'posts#view_posts'
  get 'users/add_avatar/:id' => 'users#add_avatar'
  post 'friendship/create/:id' => 'friendship#create'
  post 'friendship/unfriend/:id' => 'friendship#unfriend'
  post 'friendship/accept/:id' => 'friendship#accept'
  post 'friendship/decline/:id' => 'friendship#decline'
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

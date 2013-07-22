Shapd::Application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/shop'
        
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
    resources :splashes
    resources :feedbacks

  resources :shapes

   # devise_for :users
    devise_for :users,
    :controllers => { :sessions => 'devise/sessions', :omniauth_callbacks => "users/omniauth_callbacks" },
    :skip => [:sessions] do
        post '/login' => 'devise/sessions#create', :as => :user_session
        get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
        get '/register' => 'devise/registrations#new', :as => :new_user_registration
    end
    
    # demo app routes
    get '/demo/' => 'shapd_app#index'
    get '/demo/:id' => 'shapd_app#edit'
    
    # for the splashes (temporary emails from the splash page)
    post '/signup'  => 'splashes#create'
    
    # for creating and updating shapes
    post '/new' => 'shapes#create'
    post '/save' => 'shapes#save'
    
    get '/library' => 'home#library'
    get '/gallery' => 'home#gallery'
    
    post '/meta' => 'shapes#screenshot'
    post '/trash' => 'shapes#destroy'
    
    post '/pricing' => 'shapes#price'
    post '/pricing2' => 'shapes#shapeways_price'
    
    post '/sendtest' => 'splashes#send_test'
    post '/sendall' => 'splashes#send_all'
    
    get '/compose' => 'splashes#compose'
    get '/response' => 'shapd_app#resp'
    
    post '/produce' => 'shapes#make_product'
    post '/pricing3' => 'shapes#resin_price'
    
    post '/publish' => 'shapes#make_public'
    get '/login_other' => 'shapd_app#login'
    
    post '/feedback' => 'feedback#create'
    
    devise_scope :person do
        get '/login', :to => "devise/sessions#new"
        get '/signup', :to => "devise/registrations#new"
        delete '/logout', :to => "devise/sessions#destroy"
    end


  resources :authentications
  get "home/index"
  root "home#index"
    
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

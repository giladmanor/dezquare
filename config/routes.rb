Dezquare::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  # devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :registrations => 'register'}
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    match "/signup" , {:controller =>"registrations", :action=>"new"}
    #get "/designer_signup", {:controller =>"registrations", :action=>"register_designer"}
    #put "/designer_signup", {:controller =>"registrations", :action=>"register_designer_success"}
    match "/designer_signup" => 'registrations#register_designer', :via => :get
    match "/registrations/register_designer_success" => 'registrations#register_designer_success', :as=>"/designer_signup", :via => :post
  end

  devise_scope :user do
    match '/logout(.:format)', {:action=>"destroy", :controller=>"devise/sessions"}
  end

  #get '*foo', to: 'd#maintain'   ##########:: MAINTENANCE MODE
  get "confirm/email"
  match 'site/contact' => 'site#contact', :as => 'contact', :via => :get
  match 'site/contact' => 'site#contact_sent', :as => 'contact', :via => :post
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'ßß
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
  match 'site/index', :to=> "home#index"
  
  root :to => 'home#index'
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  
  #match 'd(/:id)', :to => "d#index" 
  
  match 'designer/profile(/:id(/:lalala))', :to=> "designer#profile"
  match ':controller(/:action(/:id))(.:format)'
  match 'soooo(/:id)', :to=> "persona#index"
  match ':id',:to => 'd#index'
  
end

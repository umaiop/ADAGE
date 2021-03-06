Ada::Application.routes.draw do
  get "welcome/index"
  get "profile" => 'welcome#profile'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data"

  resources :groups do
    collection do
    # get :playsquads
    end
  end

  match "save_game" => "save#save", :via => :post
  match "load_game" => "save#load", :via => :get
  
  match "game_version_data/save" => 'gv#save', :via => :post
  match "game_version_data/delete" => 'gv#delete', :via => :post
  match "game_version_data" => 'gv#show', :via => :get

  resources :roles
  resources :participant_roles

  resources :games do
    member do
      post :search_users 
      get :select_graph_params
      post :value_over_time
      get :statistics
      get :sessions
      get :contexts
      get :developer_tools
      get :researcher_tools
    end
  end
  resources :implementations
  resources :data do
    collection do
      post :tenacity_player_stats
      get :find_tenacity_player
      get :data_by_version
      get :export
      get :session_logs
      get :context_logs
    end
  end

  resources :users do
    collection do
      get :new_sequence
      post :create_sequence
      post :find
      get :admin
      get :reset_password_form
      put :reset_password
    end
    member do
      get :data_by_game
      get :stats
      get :session_logs
      get :context_logs
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  post '/auth/guest' => 'oauth#guest'
  get '/auth/adage_user' => 'oauth#adage_user'
  post '/oauth/token' => 'oauth#access_token'
  get '/auth/failure' => 'oauth#failure'
  post '/auth/authorize_unity' => 'oauth#authorize_unity'
  post '/auth/authorize_unity_fb' => 'oauth#authorize_unity_fb'
  post '/auth/authorize_brainpop' => 'oauth#authorize_brainpop'
  post '/auth/register' => 'oauth#client_side_create_user'

  root :to => 'welcome#index'
end

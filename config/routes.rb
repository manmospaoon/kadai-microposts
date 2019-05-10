Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    get 'signup', to: 'users#new'
    resources :users, only: [:index, :show, :new, :create] do
    #resources には member と collection という URL を深掘りするオプションを付与することができる。
     member do
      get :followings
      get :followers
      get :likes
      
     end
     #collection do
      #get :search
     #end
    end
    #             Prefix Verb   URI Pattern                     Controller#Action
    #followings_user GET    /users/:id/followings(.:format) users#followings
    # followers_user GET    /users/:id/followers(.:format)  users#followers
    #   search_users GET    /users/search(.:format)         users#search
    # collectionは、:idがつかない。

    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
end

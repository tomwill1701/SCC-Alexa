Rails.application.routes.draw do

  namespace :api do

    resources :jobs do
      member do
        get 'index'
        get 'show'
        get 'run'
      end
    end
    resources :runs, only: [:index, :show] do
      member do
        get 'delete'
      end
    end

    namespace :alexa do
      resource :handler, only: [:create]
    end

  end

  get 'auth/auth0/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'

  ActiveAdmin.routes(self)
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  root "welcome#index"
  get 'welcome/index'

  post 'application/signin'
  delete 'application/signout'
  get 'application/signout'

  get 'prompt/show'
  post 'prompt/create'

  resources :home

  resources :users

  resources :jobs do
    member do
      post 'favorite'
      delete 'unfavorite'
      get 'clone'
      get 'run'
      get 'ecmd'
    end
    collection do
      get 'search'
    end
  end

  resources :runs do
    member do
      get 'execute'
    end
  end

  resources :run_views do
    member do
      get 'job'
    end
  end

end

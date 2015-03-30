Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  root "welcome#index"
  get 'welcome/index'

  post 'application/signin'
  delete 'application/signout'

  get 'prompt/show'
  post 'prompt/create'

  resources :users

  resources :jobs do
    member do
      post 'favorite'
      delete 'unfavorite'
      get 'clone'
      get 'run'
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

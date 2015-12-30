Rails.application.routes.draw do

  devise_for :users
  root 'pages#home'
  resources :projects, only: [:index, :show, :edit, :update] do
    member do 
      post :collaborators
    end

    resources :tickets do
      member do
        post :watch
      end
    end
  end

  resources :tickets, only: [] do
    resources :comments, only: [:create]
    resources :tags, only: [] do
      member do
        delete :remove
      end
    end
  end

  resources :attachments, only: [:show, :new]

  namespace :admin do
    root "application#index"
    resources :projects, only: [:new, :create, :destroy]
    resources :states, only: [:index, :new, :create] do
      member do
        get :make_default
      end
    end
    resources :users do
      member do
        patch :archive
      end
    end
  end

  namespace :api do
    resources :projects do
      resources :tickets
    end
  end
end

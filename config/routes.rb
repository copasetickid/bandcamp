Rails.application.routes.draw do

  devise_for :users
  root 'projects#index'
  resources :projects do
    resources :tickets
  end

  namespace :admin do
    root "application#index"
  end
end

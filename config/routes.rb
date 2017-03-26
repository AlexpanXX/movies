Rails.application.routes.draw do
  devise_for :users
  resources :films do
    member do
      post :favorite
      post :dislikes
    end
    resources :comments
  end

  namespace :account do
    resources :films
    resources :comments
  end
  
  root "films#index"
end

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  resources :users, only: %i[show index] do
    member do
      get :followings, to: 'users#followings_index'
      get :followers, to: 'users#followers_index'
    end
  end

  resources :relationships, only: %i[create destroy]
  resources :meal_posts, only: %i[create destroy show]
end

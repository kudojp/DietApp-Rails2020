Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  resources :users, only: %i[show index] do
    member do
      get :followings, to: 'users#followings_index'
      get :followers, to: 'users#followers_index'
      get :upvotes, to: 'meal_posts#upvoted_index'
      get :downvotes, to: 'meal_posts#downvoted_index'
    end
  end

  resources :relationships, only: %i[create destroy]
  resources :meal_posts, only: %i[create destroy show] do
    patch :upvote, to: 'votes#upvote'
    patch :downvote, to: 'votes#downvote'
  end
  resources :votes, only: %i[create destroy]
end

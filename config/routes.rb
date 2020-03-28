Rails.application.routes.draw do
<<<<<<< HEAD
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'devise/registrations' }
=======
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
>>>>>>> Use social login by facebook account

  root to: 'home#index'

  get 'users/facebook_auth/sign_up', to: 'users/facebook_users#new', as: :new_facebook_user_registration
  post 'facebook_users', to: 'users/facebook_users#create'

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
    get :upvoters, to: 'users#upvoters_index'
    get :downvoters, to: 'users#downvoters_index'
  end
  resources :votes, only: %i[create destroy]
end

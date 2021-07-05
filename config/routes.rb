Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'home#index'

  get 'profile/edit', to: 'users#edit_profile'
  match 'profile', to: 'users#update_profile', via: %i[put post]
  get 'password/edit', to: 'users#edit_password'
  match 'password', to: 'users#update_password', via: %i[put post]

  get 'cancellation/confirmation', to: 'users#destroy_confirmation'
  delete 'cancellation', to: 'users#destroy'

  get 'users/facebook_auth/sign_up', to: 'users/facebook_users#new', as: :new_facebook_user_registration
  post 'facebook_users', to: 'users/facebook_users#create'

  devise_scope :user do
    get 'users/cancel', to: 'devise/registrations#cancel', as: :cancel_user_registration
    get '/users/sign_up', to: 'devise/registrations#new', as: :new_user_registration
    delete '/users', to: 'devise/registrations#destroy', as: :user_registration
    post '/users', to: 'devise/registrations#create'
  end

  resources :users, only: %i[show index] do
    member do
      get :followings, to: 'users#followings_index'
      get :followers, to: 'users#followers_index'
      get :upvotes, to: 'meal_posts#upvoted_index'
      get :downvotes, to: 'meal_posts#downvoted_index'
    end
  end

  resources :relationships, only: %i[create destroy]
  resources :meal_posts, only: %i[create destroy show update] do
    patch :upvote, to: 'votes#upvote'
    patch :downvote, to: 'votes#downvote'
    get :upvoters, to: 'users#upvoters_index'
    get :downvoters, to: 'users#downvoters_index'
  end
  resources :votes, only: %i[create destroy]
  resources :conversations, only: %i[index show]
end

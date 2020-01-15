# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }
  resources :users, only: [] do
    collection do
      post 'aws_auth', defaults: { format: 'json' }
    end
  end

  root to: 'home#index', defaults: { format: 'html' }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end

# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :cources, only: %i[new create]

    root 'cources#new'
  end

  resource :cources, only: :show

  root 'courses#show'
end

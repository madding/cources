# frozen_string_literal: true

Rails.application.routes.draw do
  resource :cources, only: :show

  root 'courses#show'
end

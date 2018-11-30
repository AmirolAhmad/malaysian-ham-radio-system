Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations',
    confirmations: 'admins/confirmations',
    passwords: 'admins/passwords',
    unlocks: 'admins/unlocks'
  }
  root 'home#index'
end

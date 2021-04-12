Rails.application.routes.draw do
  get 'user_inputs/create'
  get 'user_inputs/update'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'assmats/refresh', to: 'assmats#refresh'
  resources :assmats, only: [:index, :show]
  resources :user_inputs, only: [:index, :show, :create, :update]

end

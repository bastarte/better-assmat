Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'assmats/refresh', to: 'assmats#refresh'
  resources :assmats, only: [:index, :show]

end

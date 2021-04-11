Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :artworks, only: [:index, :show]

  resources :departments, only: [:index] do
    resources :artworks, only: [:index]
  end

end

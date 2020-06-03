Rails.application.routes.draw do
  devise_for :users
  namespace :api do
  		namespace :v1 do
 			resources :sessions, only: [:create]
 			resources :twitts, except: [:new, :edit]
 			delete 'sessions/logout', to: "sessions#logout"
 			post 'sessions/user_registration', to: "sessions#user_registration"
 	 	end
	end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

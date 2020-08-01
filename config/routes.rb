Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/editors', to: 'editors#index'
  post '/editors', to: 'editors#create'
  put '/editors', to: 'editors#edit'
  delete '/editors', to: 'editors#delete'
  get '/about', to: 'about#index'
end

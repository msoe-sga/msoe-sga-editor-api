Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/editors', to: 'editors#index'
  post '/editors', to: 'editors#create'
  put '/editors', to: 'editors#edit'
  delete '/editors', to: 'editors#delete'
  get '/about', to: 'about#index'
  get '/about/preview', to: 'about#preview'
  put '/about', to: 'about#edit'
  get '/posts', to: 'posts#index'
  get '/posts/preview', to: 'posts#preview'
  post '/posts', to: 'posts#create'
  put '/posts', to: 'posts#create'
end

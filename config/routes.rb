Rails.application.routes.draw do
  resources :test_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    get '/test/index' ,to: 'testuser#index'
  end

  scope :user do
    post '/login', to: 'users#create'
    post '/read',to: 'users#read'
    post '/collect',to: 'users#collect'
    post '/article', to: 'users#article'
    post '/article/add',to:'wearticle#create'
    post '/article/read',to: 'wearticle#read'
    post '/article/agree',to: 'wearticle#agree'
    post '/article/collect',to: 'wearticle#collect'
  end

  scope :article do
    # 获取文章接口
    post '/recom',to: 'wearticle#recommend'
    post '/all',to:'wearticle#index'
  end
end

Rails.application.routes.draw do
  resources :test_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    get '/test/index' ,to: 'testuser#index'
  end

  scope :user do
    post '/login', to: 'users#create'
    post '/article', to: 'users#article'
    post '/article/add',to:'wearticle#create'
  end

  scope :article do
    # 获取文章接口
    post '/recom',to: 'wearticle#recommend'
    post '/all',to:'wearticle#index'
    post '/read',to: 'wearticle#read'
  end
end

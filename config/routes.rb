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
    post '/article/delete',to:'wearticle#delete'


    post '/article/read',to: 'wearticle#read'
    post '/article/agree',to: 'wearticle#agree'
    post '/article/collect',to: 'wearticle#collect'
    ## 用户评论的添加和删除
    post '/article/comment/index',to: 'comment#create'
    post '/article/comment/delete',to: 'comment#delete'
  end

  scope :article do
    # 获取文章接口
    post '/recom',to: 'wearticle#recommend'
    post '/all',to:'wearticle#index'
    post 'search',to:'wearticle#search'
  end

  scope :super do
    # 获取全部用户信息
    get '/user/all', to: 'super#user'
    # 获取某个用户信息
    get '/user/one', to: 'super#oneUser'


    get '/index', to: 'super#index'
    # get '/index', to: 'super#index'

    get '/create',to: 'super#create'
    get '/login',to: 'super#login'

    ## 删除某个用户
    get '/user/delete',to: 'super#delete'
    get '/article/delete', to: 'super#article'
    get '/comment',to: 'super#comment'


    ## 文章加为精华帖
    get '/article/elite',to: 'super#elite'

  end


  scope :camp do
    get '/index',to: 'camps#create'
    get '/all',to:'camps#all'
    get '/answer/add',to: 'camps#answer'
    get '/user/add',to: 'camps#addUser'


    post '/wechat/answer/all',to: 'camps#weall'
  end



end

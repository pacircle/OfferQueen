require 'net/https'
require "uri"
# require 'aes'
require "base64"

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:read,:article,:collect,:getSign,:invite]

  # APPID = 'wx6e1ee86184594b21'
  APPSECRET = '0bdc57d368b2a89761867ad5c395cefa'
  SERVER = 'https://api.weixin.qq.com/sns/jscode2session?'
  SERVER1 = 'https://api.weixin.qq.com/cgi-bin/token?'
  SERVER2 = 'https://api.weixin.qq.com/wxa/getwxacodeunlimit?'

  def index

  end

  def create
    appId = params[:appId] || ''
    secretId = APPSECRET
    jsCode = params[:jsCode] || '0238OUK31ABo7O1Qb8M31LQWK318OUKp'
    grantType = params[:grant_type] || ''
    userInfo = params[:userInfo] || {}
    code = {:appId => appId,:secret => secretId,:js_code => jsCode, :grant_type => grantType,:userInfo => userInfo}
    # p code
    self.wechatget(code)
  end

  def article
    # 获取用户的文章列表
    p 'user article'
    openid = params[:openid] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      user_article = []
      users = User.where(:_id => openid)
      Article.where(:userId => openid).each do |item|
        item[:avatarUrl] = users[0].avatarUrl
        item[:nickName] = users[0].nickName
        item.time = item.time[0...item.time.length-6]
        if users[0].agreeList.include?(item._id.to_s)
          item[:user_agree] = true
        else
          item[:user_agree] = false
        end
        if users[0].collectList.include?(item._id.to_s)
          item[:user_collect] = true
        else
          item[:user_collect] = false
        end
        user_article.push(item)
      end
      render json: {:state => 200,:status => 'success',:msg => '获取用户文章',:articleList => user_article},callback: params[:callback]
    else
      render json: {:state => 400,:status => 'fail',:msg => '用户id错误'},callback: params[:callback]
    end
  end

  def read
    # 获取阅读列表
    p 'user read'
    openid = params[:openid] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      readLists = []
      user = User.where(:_id => openid)
      readList = user[0].readList
      if readList.length > 0
        readList.each do |article|
          article_read = Article.where(:_id => BSON::ObjectId(article))
          article_read.each do |item|
            p item
            users = User.where(:_id => item.userId)
            item[:avatarUrl] = users[0].avatarUrl
            item[:nickName] = users[0].nickName
            item.time = item.time[0...item.time.length-6]
            if users[0].agreeList.include?(item._id.to_s)
              item[:user_agree] = true
            else
              item[:user_agree] = false
            end
            if users[0].collectList.include?(item._id.to_s)
              item[:user_collect] = true
            else
              item[:user_collect] = false
            end
            readLists.push(item)
          end
          # user = User.where(:_id => article_read[0].userId)
          # article[:avatarUrl] = user[0].avatarUrl
          # article[:nickName] = user[0].nickName
          # article.time = article.time[0...article.time.length-6]
          # readLists.push(article_read)
        end
      end
      render json: {:state => 200,:status =>  'success',:msg => '获取阅读文章历史',:readList => readLists},callback: params[:callback]
    else
      render json: {:state => 400,:status => 'fail',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def collect
    # 获取用户收藏列表
    p 'user collect'
    openid = params[:openid] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      collectLists = []
      user = User.where(:_id => openid)
      collectList = user[0].collectList
      if collectList.length > 0
        collectList.each do |article|
          article_read = Article.where(:_id => BSON::ObjectId(article))
          article_read.each do |item|
            users = User.where(:_id => item.userId)
            item[:avatarUrl] = users[0].avatarUrl
            item[:nickName] = users[0].nickName
            item.time = item.time[0...item.time.length-6]
            if users[0].agreeList.include?(item._id.to_s)
              item[:user_agree] = true
            else
              item[:user_agree] = false
            end
            if users[0].collectList.include?(item._id.to_s)
              item[:user_collect] = true
            else
              item[:user_collect] = false
            end
            collectLists.push(item)
          end
        end
      end
      render json: {:state => 200,:status => 'success',:msg => '获取收藏文章',:collectList => collectLists},callback: params[:callback]
    else
      render json: {:state => 400,:status => 'fail',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def wechatget(message)
    uri = URI.parse(SERVER)
    data = message
    p data[:userInfo][:gender]
    uri.query = URI.encode_www_form(data)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    # p 'response.body'
    # p response.body
    if (JSON.parse response.body)['errcode']
      error_detail = JSON.parse response.body
      # render json: {:state => 'fail',:msg => '获取id失败',:error_detail => error_detail}
      render json: {:state => 'error',:msg => '获取id失败'}
    else if (JSON.parse response.body)['openid']
           backMessage = JSON.parse response.body
           openid =  backMessage['openid']
           if openid && openid.length >0 && User.where(:_id => openid).length == 0
             User.create(:_id => openid,:nickName => data[:userInfo][:nickName],
                         :avatarUrl => data[:userInfo][:avatarUrl],
                         :city => data[:userInfo][:city],
                         :country => data[:userInfo][:country],
                         :gender => data[:userInfo][:gender],
                         :language => data[:userInfo][:language],
                         :province => data[:userInfo][:province],
                         :authority => 0,
                         :inviteMember => 0,
                         :inviteList => [],
                         :phone => '',
                         :password => '',
                         :articleList => [],
                         :commentList => [],
                         # :answerList => [],
                         :agreeList => [],
                         :readList => [],
                         :collectList => [])
             render json: {:state => 'success',:msg => '用户注册成功',:openid => openid},callback: params[:callback]
           else
             render json: {:state => 'success',:msg => '用户已注册',:openid => openid},callback: params[:callback]
           end
         else
           render json: {:state => 'error',:msg => '获取id失败'},callback: params[:callback]
         end
    end
  end

  def getSign
    p 'getsign'
    appId = params[:appId] || ''
    secretId = APPSECRET
    code = {:grant_type => 'client_credential',:appid => appId,:secret => secretId}
    uri = URI.parse(SERVER1)
    data = code
    uri.query = URI.encode_www_form(data)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    p JSON.parse response.body
    if (JSON.parse response.body)['errcode']
      error_detail = JSON.parse response.body
      # render json: {:state => 'fail',:msg => '获取id失败',:error_detail => error_detail}
      render json: {:state => 'error',:msg => '获取access_token失败'}
    else if (JSON.parse response.body)['access_token']
           backMessage = JSON.parse response.body
           access_token = backMessage['access_token']
           uri2 = URI.parse(SERVER2)
           form = {:access_token => access_token}
           uri2.query = URI.encode_www_form(form)

           message = {scene: '111'}
           http2 = Net::HTTP.new(uri2.host, uri2.port)
           http2.use_ssl = true
           http2.verify_mode = OpenSSL::SSL::VERIFY_NONE
           request2 = Net::HTTP::Post.new(uri2.request_uri)
           request2.body = message.to_json.to_s
           response2 = http.request(request2)
           body = response2.body
           bytes = body.split().pack("H*")
           p bytes
           # p response2.body
           # render json: {:data => JSON.parse request2.body}
           # Filetest.create(:wxcode => bytes)
           # render json:{:data => Filetest.all}
           File.open("#{Rails.root}/public/Image/wx_qcode2.jpg", "wb+") do |f|
             f.write(response2.body)
             # p image_url(f)
             # # Filetest.create(:wxcode => f)
           end
         end
    end
  end


  def invite_create
    ## 邀请复盘文章,注册用户
    openid = params[:openid] || ''
    ## 邀请方式：article || camp
    type = params[:type] || 'article'

    appId = params[:appId] || ''
    secretId = APPSECRET
    jsCode = params[:jsCode] || '0238OUK31ABo7O1Qb8M31LQWK318OUKp'
    grantType = params[:grant_type] || ''
    userInfo = params[:userInfo] || {}
    code = {:appId => appId,:secret => secretId,:js_code => jsCode, :grant_type => grantType,:userInfo => userInfo}
    self.wechatget(code) #注册新的用户
    if openid && openid.length && User.where(:_id => openid).length > 0
      if type === 'article'
      else if type == 'camp'

           else

           end
      end
    else

    end


  end

end

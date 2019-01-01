require 'net/https'
require "uri"
# require 'aes'
require "base64"

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create]

  # APPID = 'wx6e1ee86184594b21'
  APPSECRET = '0bdc57d368b2a89761867ad5c395cefa'
  SERVER = 'https://api.weixin.qq.com/sns/jscode2session?'

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
                         :phone => '',
                         :password => '',
                         :articleList => [],
                         :commentList => [],
                         :answerList => [],
                         :agreeList => [])
             render json: {:state => 'success',:msg => '用户注册成功',:openid => openid},callback: params[:callback]
           else
             render json: {:state => 'success',:msg => '用户已注册',:openid => openid},callback: params[:callback]
           end
         else
           render json: {:state => 'error',:msg => '获取id失败'},callback: params[:callback]
         end
    end
  end
end

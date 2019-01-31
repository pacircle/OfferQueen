class FrotateController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:add,:index,:get]


  def add
    p 'add'
    name = params[:name] || ''
    password = params[:password] || ''
    address = params[:address] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if address && address.length > 0
        rotate = Rotate.create(:address => address)
        render json: {:state => 200, :status => 'success',:msg => '更新地址成功',:data => rotate},callback: params[:callback]
      else
        render json: {:state => 400, :status => 'fail',:msg => '地址不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400, :status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def index
    p 'index'
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if Rotate.last
        addressList = Rotate.last
        render json: {:state => 200, :status => 'success',:msg => '查询地址成功',:data => addressList},callback: params[:callback]
      else
        render json: {:state => 400, :status => 'fail',:msg => '查询地址不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400, :status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def get
    openid = params[:openid] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if Rotate.last
        addressList = Rotate.last
        render json: {:state => 200,:status => 'success',:msg => '获取首页地址成功',:rotate => addressList},callback: params[:callback]
      else
        render json: {:state => 400, :status => 'fail',:msg => '查询地址不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '用户id错误'},callback: params[:callback]
    end
  end

end

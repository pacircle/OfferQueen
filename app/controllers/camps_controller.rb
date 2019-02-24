class CampsController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:all,:answer, :weall,:addUser,:user,:qtcode]

  def create
    p 'create'
    order = params[:order] || ''
    content= params[:content] || ''
    description = params[:description] || ''
    startTime = params[:startTime] || ''
    endTime = params[:endTime] || ''
    name = params[:name] || ''
    password = params[:password] || ''
    signWay = params[:signWay] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      camp = Camp.create(:order => order,:content => content,:description => description,:startTime => startTime,:endTime => endTime,:answers => [],:userList => [],:signWay => signWay)
      data = {:camp => camp}
      @camp_users = User.all
      @camp_users.each do |user|
        user.update(:campMember => 0)
      end
      render json: {:state => 200,:status => 'success',:msg => '添加训练营信息成功',:data => data},callback: params[:callback]
    else
      render json: {:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def all
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      camps = Camp.all
      data = {:camps => camps}
      render json: {:state => 200,:status => 'success',:msg => '获取全部训练营信息成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def answer
    campId = params[:campId] || ''
    content = params[:content] || ''
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if campId && campId.length > 0 && Camp.where(:_id => BSON::ObjectId(campId)).length > 0
        camps = Camp.where(:_id => BSON::ObjectId(campId))
        answer = {:content => content}
        camps.each do |camp|
          answers = camp.answers
          answers.push(answer)
          camp.answers = answers
          camp.update(:answers => answers)
        end
        render json: {:state => 200,:status => 'success',:msg => '该训练营回答更新成功'},callback: params[:callback]
      else
        render json: {:state => 400,:status => 'fail',:msg => '该训练营不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end




  def weall
    #小程序用户获取训练营信息
    openid = params[:openid] || ''
    if openid && openid.length>0 && User.where(:_id => openid).length > 0
      # 用户存在
      camps = Camp.all
      data = {:camps => camps}
      render json: {:state => 200, :status =>'success',:msg => '训练营获取成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 200, :status=> 'fail',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def addUser
    name = params[:name] || ''
    password = params[:password] || ''
    userId = params[:userId] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      camps = Camp.all
      length = camps.length
      if length > 0
        if userId && userId.length > 0
          camp = camps[length - 1 ]
          userList = camp.userList
          addUserList = userId.split(",")
          p addUserList
          addUserList.each do |user|
            if userList.include?(user)
              p '用户已经存在'
            else
              userList.push(user)
            end
          end
          camp.update(:userList => userList)
          render json: {:state => 200,:status => 'success',:msg => '训练营添加用户成功'},callback: params[:callback]
          # if userList.include?(userId)
          #   render json: {:state => 403,:status => 'fail',:msg => '用户已经报名成功'},callback: params[:callback]
          # else
          #   userList.push(userId)
          #   camp.update(:userList => userList)
          #   render json: {:state => 200,:status => 'success',:msg => '训练营添加用户成功'},callback: params[:callback]
          # end
        else
          render json: {:state => 400,:status => 'fail',:msg => '无用户信息'},callback: params[:callback]
        end
      else
        render json: {:state => 400,:status => 'fail',:msg => '暂无训练营'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def user
    # 获取全部用户信息
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      @users = User.all
      camps = Camp.all
      length = camps.length
      if length > 0
        camp = camps[length - 1 ]
        userList = camp.userList
        p userList
        users = []
        @users.each do |use|
          if userList.include?(use._id)
            use[:include] = '已添加'
          else
            use[:include] = '未添加'
          end
          users.push(use)
        end
        data = {:userInfos => users}
        render json: {:state => 200,:status => 'success',:msg => '获取用户信息成功',:data => data},callback: params[:callback]
      else
        userss = []
        @users.each do |use|
          userss.push(use)
        end
        datas = {:userInfos => userss}
        render json: {:state => 200,:status => 'success',:msg => '获取用户信息成功',:data => datas},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def qtcode
    if request.method == 'OPTIONS'
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers['Access-Control-Request-Method'] = '*'
      response.headers["Access-Control-Allow-Headers"] = "Access-Control-Allow-Origin,Origin,X-Requested-With,Content-type,Accept,Access-Control-Allow-Headers, Authorization, X-Requested-With,Access-Control-Allow-Origin"
      response.headers["Access-Control-Allow-Methods"] = "PUT,POST,GET,DELETE,OPTIONS"
      response.headers["Access-Control-Allow-Credentials"] = "true"
      response.headers["Cache-Control"] = "no-cache"
      p params
      p response
      render json: {:states => 400}
    else if request.method == 'POST'
           p response
           response.headers["Access-Control-Allow-Origin"] = "*"
           response.headers['Access-Control-Request-Method'] = '*'
           response.headers["Access-Control-Allow-Headers"] = "Access-Control-Allow-Origin,Origin,X-Requested-With,Content-type,Accept,Access-Control-Allow-Headers, Authorization, X-Requested-With,Access-Control-Allow-Origin"
           response.headers["Access-Control-Allow-Methods"] = "PUT,POST,GET,DELETE,OPTIONS"
           response.headers["Access-Control-Allow-Credentials"] = "true"
           response.headers["Cache-Control"] = "no-cache"
           response.to_json
           # @filesss = IO.read(file).force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
           # p @filesss
           p 'post'
         end
    end
  end

end

class SuperController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:login,:create,:delete,:user,:index,:article,:comment]

  # def login
  #   name = params[:name] || ''
  #   password = params[:password] || ''
  #   if name && password && name.length > 0 && password.length > 0 && SuperUser.where(:name => name).length > 0
  #
  #   else
  #     render json: {:status => 'fail',:msg => '管理员登陆失败'},callback: params[:callback]
  #   end
  # end

  def login
    name = params[:name] || ''
    password = params[:password] || ''
    if name && name.length > 0 && SuperUser.where(:name=> name).length > 0
      superUser = SuperUser.where(:name=> name)
      superUser.each do |suser|
        if suser.password == password
          render json: {:status => 'success',:msg => '用户验证成功'},callback: params[:callback]
        else
          render json: {:status => 'fail',:msg => '用户密码错误'},callback: params[:callback]
        end
      end
    else
      render json: {:status => 'fail',:msg => '用户不存在'},callback: params[:callback]
    end
  end

  def create
    name = params[:name] || ''
    password = params[:password] || ''
    secretCode = params[:secretCode] || ''
    if secretCode == 'offerqueen'
      if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length === 0
        SuperUser.create(:name => name,:password => password)
        render json: {:status => 'success',:msg => '创建管理员用户信息成功'},callback: params[:callback]
      else
        render json: {:status => 'fail',:msg => '创建管理员用户信息失败'},callback: params[:callback]
      end
    else
      render json: {:status => 'fail',:msg => '无创建管理员用户权限'},callback: params[:callback]
    end
  end

  def user
    # 获取全部用户信息
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      @users = User.all
      data = {:userInfos => @users}
      render json: {:status => 'success',:msg => '获取用户信息成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 'fail',:msg => '用户验证失败'},callback: params[:callback]
    end
  end



  def index
    # 获取全部文章信息
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      articleList = []
      articles = Article.all
      articles.each do |article|
        user = User.where(:_id => article.userId)
        article[:avatarUrl] = user[0].avatarUrl
        article[:nickName] = user[0].nickName
        article.time = article.time[0...article.time.length-6]
        articleList.push(article)
      end
      data = {:articleInfos => articleList}
      render json: {:state => 'success',:msg => '文章列表获取成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 'fail',:msg => '用户验证失败'},callback: params[:callback]
    end
    # if User.where(:_id => openid).length > 0 || articleType.length >0
    #   articleList = []
    #   @articles = Article.all.sort_by{|u| u.time}.reverse()
    #   @articles.each do |article|
    #     user = User.where(:_id => article.userId)
    #     article[:avatarUrl] = user[0].avatarUrl
    #     article[:nickName] = user[0].nickName
    #     article.time = article.time[0...article.time.length-6]
    #     articleList.push(article)
    #   end
    #   render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => articleList},callback: params[:callback]
    # end
  end


  def delete
    # 删除用户
    userId = params[:userId] || ''
    name = params[:name] || ''
    password = params[:password] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if userId && userId.length > 0 && User.where(:_id => userId).length > 0
        @user = User.where(:_id => userId)
        @user.each do |user|
          user.delete
        end
        if Article.where(:userId => userId).length > 0
          @articles = Article.where(:userId => userId)
          @articles.each do |article|
            article.delete
          end
        end
        if Comment.where(:userId => userId).length > 0
          @comments = Comment.where(:userId => userId)
          @comments.each do |comment|
            comment.delete
          end
        end
        render json: {:status => 'success',:msg => '删除用户信息成功'},callback: params[:callback]
      else
        render json: {:status => 'fail',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'fail',:msg => '用户验证失败'},callback: params[:callback]
    end
  end


  def article
    # 删除文章
    name = params[:name] || ''
    password = params[:password] || ''
    articleId = params[:articleId] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if articleId && articleId.length > 0 && Article.where(:_id => BSON::ObjectId(articleId)).length > 0
        articless = Article.where(:_id => BSON::ObjectId(articleId))
        articless.each do |article|
          article.delete
        end
        comments = Comment.where(:articleId => articleId)
        comments.each do |comment|
          comment.delete
        end
        render json: {:state => 'success',:msg => '文章删除成功'},callback: params[:callback]
      else
        render json: {:state => 'fail',:msg => '文章不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'fail',:msg => '用户验证失败'},callback: params[:callback]
    end
  end

  def comment
    # 删除评论
    name = params[:name] || ''
    password = params[:password] || ''
    commentId = params[:commentId] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if commentId && commentId.length > 0 && Comment.where(:_id => BSON::ObjectId(commentId)).length > 0
        comments = Comment.where(:_id => BSON::ObjectId(commentId))
        comments.each do |comment|
          article = Article.where(:_id => comment.articleId)
          article.each do |art|
            art.commentList.delete(commentId)
          end
          comment.delete
        end
        render json: {:status => 'success',:msg => '删除评论成功'},callback: params[:callback]
      else
        render json: {:status => 'fail',:msg => '评论不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'fail',:msg => '用户验证失败'},callback: params[:callback]
    end
  end



end
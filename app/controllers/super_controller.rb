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
      render json: {:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
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
      users = []
      @users.each do |use|
        # use.articleList.each do |article|
        #   art = Article.where(:_id => BSON::ObjectId(article._id))
        #   articles.push(art)
        # end
        # p Article.where(:userId => use._id).length
        # articless = []
        # Article.where(:userId => use._id).each do |art|
        #   articless.push(art)
        # end
        # use[:articless] = articless
        # p use[:articless].length
        articles = []
        Article.where(:userId => use._id).each do |article|
          p article
          articles.push(article)
        end
        p articles
        use.articleList = articles
        users.push(use)
      end
      data = {:userInfos => users}
      render json: {:state => 200,:status => 'success',:msg => '获取用户信息成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 400,:state => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
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
      render json: {:state => 200,:status => 'success',:msg => '文章列表获取成功',:data => data},callback: params[:callback]
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
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
        userss = User.all
        if Article.where(:userId => userId).length > 0
          @articles = Article.where(:userId => userId)
          @articles.each do |article|
            userss.each do |user|
              if user.readList.include?(article._id.to_s)
                readList = user.readList
                readList.delete(articleId)
                user.update(:readList => readList)
              end
              if user.agreeList.include?(article._id.to_s)
                agreeList = user.agreeList
                agreeList.delete(articleId)
                user.update(:agreeList => agreeList)
              end
              if user.collectList.include?(article._id.to_s)
                collectList = user.collectList
                collectList.delete(articleId)
                user.update(:collectList => collectList)
              end
            end
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
      render json: {:state => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
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
          use = User.where(:_id => article.userId)
          articleList = use[0].agreeList
          articleList.delete(article._id.to_s)
          use.update(:articleList => articleList)
          article.delete
        end
        users = User.all
        users.each do |user|
          if user.readList.include?(articleId)
            readList = user.readList
            readList.delete(articleId)
            user.update(:readList => readList)
          end
          if user.agreeList.include?(articleId)
            agreeList = user.agreeList
            agreeList.delete(articleId)
            user.update(:agreeList => agreeList)
          end
          if user.collectList.include?(articleId)
            collectList = user.collectList
            collectList.delete(articleId)
            user.update(:collectList => collectList)
          end
        end
        comments = Comment.where(:articleId => articleId)
        comments.each do |comment|
          # use = User.where(:_id => comment.userId)
          # commentList = use[0].commentList
          # commentList .delete(comment._id.to_s)
          # use.update(:commentList => commentList)
          comment.delete
        end
        render json: {:state => 200,:status => 'success',:msg => '文章删除成功'},callback: params[:callback]
      else
        render json: {:state => 400,:status => 'fail',:msg => '文章不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
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
        render json: {:state => 200,:status => 'success',:msg => '删除评论成功'},callback: params[:callback]
      else
        render json: {:state => 400,:status => 'fail',:msg => '评论不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def oneUser
    name = params[:name] || ''
    password = params[:password] || ''
    userId = params[:userId] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      if userId && userId.length > 0 && User.where(:_id => userId).length > 0
        users = User.where(:_id => userId)
        users.each do |user|
          articles = []
          Article.where(:userId => user._id).each do |article|
            p article
            article[:avatarUrl] = user.avatarUrl
            article[:nickName] = user.nickName
            article.time = article.time[0...article.time.length-6]
            articles.push(article)
          end
          user[:articleDetail] = articles
          # p articles
          # user.articleList = articles
          # user.push(use)
          # articleList = []
          #       articles = Article.all
          #       articles.each do |article|
          #         user = User.where(:_id => article.userId)
          #         article[:avatarUrl] = user[0].avatarUrl
          #         article[:nickName] = user[0].nickName
          #         article.time = article.time[0...article.time.length-6]
          #         articleList.push(article)
          #       end
          data = {:userInfo => user}
          render json: {:state => 200,:status => 'success',:msg => '获取单个用户信息成功',:data => data},callback: params[:callback]
        end
      else
        render json: {:state => 400,:status => 'fail',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 400, :status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end


  def elite
    ## 文章加为精华帖
    name = params[:name] || ''
    password = params[:password] || ''
    articleId = params[:articleId] || ''
    if name && password && name.length > 0 && password.length >0 && SuperUser.where(:name=> name).length > 0
      p Article.where(:_id => BSON::ObjectId(articleId)).length
      if articleId && articleId.length > 0 && Article.where(:_id => BSON::ObjectId(articleId)).length > 0
        article = Article.where(:_id => articleId)
        article.each do |art|
          art.update(:elite => 1)
        end
        render json: {:state => 200,:status => 'success',:msg => '文章加精成功'},callback: params[:callback]
      else
        render json: {:state => 400, :status => 'fail',:msg => '文章加精失败'},callback: params[:callback]
      end
    else
      render json: {:state => 400, :status => 'fail',:msg => '管理员验证失败'},callback: params[:callback]
    end
  end

end

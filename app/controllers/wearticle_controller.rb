class WearticleController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:index,:recommend,:read]

  def index
    # 返回全部文章列表
    openid = params[:openid] || ''
    articleType = params[:articleType] || 'time'
    if openid && openid.length>=0
      if User.where(:_id => openid).length > 0 || articleType.length >0
        # 用户存在
        case articleType
        when "time"
          p 'time'
          @articles = Article.all.sort_by{|u| u.time}.reverse()
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => @articles},callback: params[:callback]
        when "comment"
          p 'comment'
          @articles = Article.all.sort_by{|u| u.commentList.length}.reverse()
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => @articles},callback: params[:callback]
        when "agree"
          p 'agree'
          @articles = Article.all.sort_by{|u| u.agree}.reverse()
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => @articles},callback: params[:callback]
        else
          p 'else time'
          @articles = Article.all.sort_by{|u| u.time}.reverse()
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => @articles},callback: params[:callback]
        end
      else
        render json: {:state => 'error',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end

  def recommend
    # 返回推荐文章列表
    openid = params[:openid] || ''
    if openid && openid.length>0
      if User.where(:_id => openid).length > 0
        # 用户存在
        reArticles = Article.where(:elite => 1)
        if reArticles.length > 0
          # reArticless = new Array
          # reArticle.map { |item|
          #   @user = User.where(:_id => item.userId)
          #   if @user
          #     if @user[0].agreeList.include? item._id
          #       # item.avatarUrl = @user[0].avatarUrl
          #       # item.nickName = @user[0].nickName
          #       # item.user_agree = true
          #     else
          #       # item.user_agree = false
          #     end
          #   end
          #   }
          render json: {:state => 'success',:msg => '推荐文章获取成功',:recomInfos => reArticles},callback: params[:callback]
        else
          render json: {:state => 'success',:msg => '无推荐文章',:recomInfos => []},callback: params[:callback]
        end
      else
        render json: {:state => 'error',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end

  def create
    openid = params[:openid] || ''
    content = params[:content] || ''
    sub = params[:sub] || ''
    title = params[:title] || ''
    if openid && openid.length>0
      if User.where(:_id => openid).length > 0
        @article = Article.create(:userId => openid,:elite => 0,
                                  :content => content,
                                  :time => Time.now,
                                  :title => title,
                                  :sub => sub,
                                  :agree => 0,
                                  :commentList => [],
                                  :readTime => 0)
        @article.save
        articleItem = {:id => @article._id,:time => '刚刚'}
        render json: {:state => 'success',:msg => '文章上传成功',:articleItem => articleItem},callback: params[:callback]
      else
        render json: {:state => 'error',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def read
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId
        @article_read = Article.where(:_id => BSON::ObjectId(articleId))
        @article_read.each do |article|
          readTime = article.readTime + 1
          article.update(:readTime => readTime)
          user = User.where(:_id => openid)
          readList = user[0].readList
          readList.push(articleId)
          user.update(:readList => readList)
        end
        render json: {:state => 'success',:msg => '文章阅读更新成功'},callback: params[:callback]
      else
        render json: {:state => 'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end


end

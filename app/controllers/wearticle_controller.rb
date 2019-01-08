class WearticleController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:index,:recommend,:read,:agree,:collect]

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
          articleList = []
          @articles = Article.all.sort_by{|u| u.time}.reverse()
          @articles.each do |article|
            user = User.where(:_id => article.userId)
            article[:avatarUrl] = user[0].avatarUrl
            article[:nickName] = user[0].nickName
            article.time = article.time[0...article.time.length-6]
            # if article.day < Time.now.day - 2
            #   article.time = article.time[0...article.time.length-6]
            # else if article.day < Time.now.day - 1
            #        article.time = "前天"
            #        # case article.hour
            #        # when
            #        # when
            #        # when
            #        # else
            #        #
            #        # end
            #      else if article.day < Time.now.day
            #             article.time = "昨天"
            #           else
            #             case Time.now.hour - article.hour
            #             when 1
            #               article.time = "昨天"
            #             when 2
            #             when 3
            #             when 4
            #             when 5
            #             when 6
            #             when 7
            #             when 8
            #             when 9
            #             when 10
            #             when 11
            #             when 12
            #             when 13
            #             when 14
            #             when 15
            #             when 16
            #             when 17
            #             when 18
            #             when 19
            #             else
            #
            #             end
            #           end
            #      end
            # end
            articleList.push(article)
          end
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => articleList},callback: params[:callback]
        when "comment"
          p 'comment'
          articleList = []
          @articles = Article.all.sort_by{|u| u.commentList.length}.reverse()
          @articles.each do |article|
            user = User.where(:_id => article.userId)
            article[:avatarUrl] = user[0].avatarUrl
            article[:nickName] = user[0].nickName
            article.time = article.time[0...article.time.length-6]
            articleList.push(article)
          end
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => articleList},callback: params[:callback]
        when "agree"
          p 'agree'
          articleList = []
          @articles = Article.all.sort_by{|u| u.agree}.reverse()
          @articles.each do |article|
            user = User.where(:_id => article.userId)
            article[:avatarUrl] = user[0].avatarUrl
            article[:nickName] = user[0].nickName
            article.time = article.time[0...article.time.length-6]
            articleList.push(article)
          end
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => articleList},callback: params[:callback]
        else
          p 'else time'
          articleList = []
          @articles = Article.all.sort_by{|u| u.time}.reverse()
          @articles.each do |article|
            user = User.where(:_id => article.userId)
            article[:avatarUrl] = user[0].avatarUrl
            article[:nickName] = user[0].nickName
            article.time = article.time[0...article.time.length-6]
            articleList.push(article)
          end
          render json: {:state => 'success',:msg => '文章列表获取成功',:articleInfos => articleList},callback: params[:callback]
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
          reArticleList = []
          reArticles.each do |article|
            user = User.where(:_id => article.userId)
            article[:avatarUrl] = user[0].avatarUrl
            article[:nickName] = user[0].nickName
            article.time = article.time[0...article.time.length-6]
            reArticleList.push(article)
          end
          render json: {:state => 'success',:msg => '推荐文章获取成功',:recomInfos => reArticleList},callback: params[:callback]
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
        @article = Article.create(:userId => openid,
                                  :elite => 1,
                                  :content => content,
                                  :time => Time.now,
                                  :title => title,
                                  :sub => sub,
                                  :agree => 10,
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


  def agree
    # 文章点赞
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId
        @article_read = Article.where(:_id => BSON::ObjectId(articleId))
        @article_read.each do |article|
          agree = article.agree + 1
          article.update(:agree => agree)
          user = User.where(:_id => openid)
          agreeList = user[0].agreeList
          agreeList.push(articleId)
          user.update(:agreeList => agreeList)
        end
        render json: {:state => 'success',:msg => '文章点赞更新成功'},callback: params[:callback]
      else
        render json: {:state => 'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def collect
    # 文章收藏
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId
        @article_read = Article.where(:_id => BSON::ObjectId(articleId))
        @article_read.each do |article|
          user = User.where(:_id => openid)
          collectList = user[0].collectList
          collectList.push(articleId)
          user.update(:collectList => collectList)
        end
        render json: {:state => 'success',:msg => '文章收藏更新成功'},callback: params[:callback]
      else
        render json: {:state => 'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end
end

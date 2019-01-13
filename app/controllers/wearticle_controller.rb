class WearticleController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:index,:recommend,:read,:agree,:collect,:delete]

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
            # p 'articleID:'
            # p article._id.to_s
            if user[0].agreeList.include?(article._id.to_s)
              article[:user_agree] = true
            else
              article[:user_agree] = false
            end
            if user[0].collectList.include?(article._id.to_s)
              article[:user_collect] = true
            else
              article[:user_collect] = false
            end
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
            p article._id.to_s
            if user[0].agreeList.include?(article._id.to_s)
              article[:user_agree] = true
            else
              article[:user_agree] = false
            end
            if user[0].collectList.include?(article._id.to_s)
              article[:user_collect] = true
            else
              article[:user_collect] = false
            end
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
            p article._id.to_s
            if user[0].agreeList.include?(article._id.to_s)
              article[:user_agree] = true
            else
              article[:user_agree] = false
            end
            if user[0].collectList.include?(article._id.to_s)
              article[:user_collect] = true
            else
              article[:user_collect] = false
            end
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
            if user[0].agreeList.include?(article._id.to_s)
              article[:user_agree] = true
            else
              article[:user_agree] = false
            end
            if user[0].collectList.include?(article._id.to_s)
              article[:user_collect] = true
            else
              article[:user_collect] = false
            end
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
            if user[0].agreeList.include?(article._id.to_s)
              article[:user_agree] = true
            else
              article[:user_agree] = false
            end
            if user[0].collectList.include?(article._id.to_s)
              article[:user_collect] = true
            else
              article[:user_collect] = false
            end
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
    if openid && openid.length > 0
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
        use = User.where(:_id => openid)
        article = use[0].articleList
        article.push(@article._id.object_id.to_s)
        use.update(:articleList => article)
        # use.each do |us|
        #   article = us.articleList
        #   p article
        #   article.push(@article._id.object_id)
        #   us.articleList = article
        #   p us.articleList
        # end
        articleItem = {:id => @article._id,:time => '刚刚'}
        render json: {:state => 'success',:msg => '文章上传成功',:articleItem => articleItem},callback: params[:callback]
      else
        render json: {:state => 'error',:msg => '用户不存在'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end

  def delete
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId  && Article.where(:_id => BSON::ObjectId(articleId)).length > 0
        article_delete = Article.where(:_id => BSON::ObjectId(articleId))
        article_delete.each do |article|
          if article.userId == openid
            userss = User.all
            ## 文章对应的评论删除
            comments = Comment.where(:articleId => articleId)
            comments.each do |comment|
              userss.each do |users|
                if users.commentList.include?(comment._id.object_id)
                  users.commentList.delete(comment._id.object_id)
                end
              end
              comment.delete
            end
            # 收藏/阅读/点赞文章全部删除
            userss.each do |users|
              if users.readList.include?(articleId)
                users.readList.delete(articleId)
              end
              if users.agreeList.include?(articleId)
                users.agreeList.delete(articleId)
              end
              if users.collectList.include?(articleId)
                users.collectList.delete(articleId)
              end
            end
            article.delete
            render json: {:state => 200,:status => 'success',:msg => '文章删除成功'},callback: params[:callback]
          else
            render json: {:state => 400,:status => 'fail',:msg => '文章删除失败,用户无权限'},callback: params[:callback]
          end
        end
      else
        render json: {:state => 400,:status => 'fail',:msg => '文章删除失败，文章不存在'},callback: params[:callback]
      end
    end
  end

  def read
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId && articleId.length > 0 && Article.where(:_id => BSON::ObjectId(articleId)).length > 0
        @article_read = Article.where(:_id => BSON::ObjectId(articleId))
        @article_read.each do |article|
          user = User.where(:_id => openid)
          readList = user[0].readList
          if readList.include?(articleId)
            readTime = article.readTime + 1
            article.update(:readTime => readTime)
            render json: {:state => 'success',:msg => '文章多次阅读'},callback: params[:callback]
          else
            readTime = article.readTime + 1
            article.update(:readTime => readTime)
            readList.push(articleId)
            user.update(:readList => readList)
            render json: {:state => 'success',:msg => '文章阅读更新成功'},callback: params[:callback]
          end
        end
      else
        render json: {:state => 'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end


  def agree
    # 文章点赞或者取消点赞
    openid = params[:openid] || ''
    articleId = params[:articleId] || ''
    if openid && openid.length > 0 && User.where(:_id => openid).length > 0
      if articleId && articleId.length > 0 && Article.where(:_id => BSON::ObjectId(articleId)).length > 0
        @article_agree = Article.where(:_id => BSON::ObjectId(articleId))
        @article_agree.each do |article|
          user = User.where(:_id => openid)
          agreeList = user[0].agreeList
          if agreeList.include?(articleId)
            ## 取消点赞
            agree = article.agree - 1
            article.update(:agree => agree)
            agreeList.delete(articleId)
            user.update(:agreeList => agreeList)
            render json: {:state => 200, :status => 'success',:msg => '已经点过赞，取消点赞'},callback: params[:callback]
          else
            agree = article.agree + 1
            article.update(:agree => agree)
            agreeList.push(articleId)
            user.update(:agreeList => agreeList)
            render json: {:state => 200,:status => 'success',:msg => '文章点赞更新成功'},callback: params[:callback]
          end
        end
      else
        render json: {:state => 400,:status => 'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'error',:msg => '用户id错误'},callback: params[:callback]
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
          if collectList.include?(articleId)
            collectList.delete(articleId)
            user.update(:collectList => collectList)
            render json: {:state => 200, :status => 'success',:msg => '已经收藏过，取消收藏'},callback: params[:callback]
          else
            collectList.push(articleId)
            user.update(:collectList => collectList)
            render json: {:state => 200, :status => 'success',:msg => '文章收藏更新成功'},callback: params[:callback]
          end
        end
      else
        render json: {:state => 400,:status =>'error',:msg => '文章id错误'},callback: params[:callback]
      end
    else
      render json: {:state => 400,:status => 'error',:msg => '用户id错误'},callback: params[:callback]
    end
  end


end

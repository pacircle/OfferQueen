class CommentController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:create,:delete]

  def create
    content = params[:content] || ''
    userId = params[:userId] || ''
    articleId = params[:articleId] || ''
    if content && userId && articleId && content.length > 0 && userId.length > 0 && articleId.length > 0 && User.where(:_id => userId).length > 0
      if articleId && Article.where(:_id => articleId)
        @comment = Comment.create(:userId => userId,:content => content,:articleId => articleId,:time => Time.now)
        @article = Article.where(:_id => BSON::ObjectId(articleId))
        @article.each do |article|
          commentList = article.commentList
          commentList.push(@comment._id)
          article.update(:commentList => commentList)
        end
        commentItem = {:id => @comment._id,:time => '刚刚'}
        render json: {:state => 'success',:msg => '添加评论成功',:commentItem => commentItem},callback: params[:callback]
      else
        render json: {:state => 'fail',:msg => '文章不存在成功'},callback: params[:callback]
      end
    else
      render json: {:state => 'fail',:msg => '用户不存在成功'},callback: params[:callback]
    end
  end

  def delete
    # 允许用户本人删除评论
    commentId = params[:commentId] || ''
    userId = params[:userId] || ''
    if commentId && commentId.length > 0 && Comment.where(:_id => BSON::ObjectId(commentId)).length > 0
      @comments = Comment.where(:_id => BSON::ObjectId(commentId))
      @comments.each do |comment|
        if comment.userId == userId
          comment.delete
          render json: {:state => 'success',:msg => '评论删除成功'},callback: params[:callback]
        else
          render json: {:state => 'fail',:msg => '用户认证失败，无法删除评论'},callback: params[:callback]
        end
      end
    else
      render json: {:state => 'fail',:msg => '评论不存在'},callback: params[:callback]
    end
  end

end

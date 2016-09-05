class CommentsController < ApplicationController

  def create
    @comments = Comment.create(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    redirect_to "/posts/#{@comments.post.id}"
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy
    end
    redirect_to user_path(current_user)
  end

  private
  def comment_params
    params.permit(:text, :post_id)
  end

end

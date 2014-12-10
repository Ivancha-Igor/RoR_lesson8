class CommentsController < ApplicationController
  before_action :authenticate, only: [:create, :update, :destroy]

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new(:parent_id => params[:parent_id], :post_id => params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: 'Ваш комментарий успешно сохранен' }
        format.js {}
      end
    end
  end

  def update
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
    if @comment.user == current_user || time?
      @comment.delete
    end
      redirect_to @post
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def time?
    (Time.now - @comment.created_at) < 3600
  end

  def comment_user
    redirect_to :back unless @comment.user == current_user
  end

end

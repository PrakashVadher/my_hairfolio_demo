class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment, status: 201
    else
      render json: { errors: @comment.errors }, status: 422
    end
  end

  def destroy
    @comment.destroy
    head 204
  end

  def update
    if @comment.update(comment_params)
      render json: @comment, status: 201
    else
      render json: { errors: @comment.errors }, status: 422
    end
  end

  def index
    comments = @post.comments.order('created_at desc').page(params[:page]).per(params[:limit])
    render json: comments, meta: pagination_dict(comments), includes: [:user]
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end

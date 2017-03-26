class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment_and_check_permission, only: [:edit, :update, :destroy]

  def new
    @film = Film.find(params[:film_id])
    @comment = Comment.new
  end

  def edit
    @film = @comment.film
  end

  def create
    @film = Film.find(params[:film_id])
    @comment = Comment.new(comment_params)
    @comment.film = @film
    @comment.user = current_user
    if @comment.save
      current_user.favorite!(@film)
      redirect_to film_path(@film)
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to film_path(@comment.film)
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def find_comment_and_check_permission
    @comment = Comment.find(params[:id])
    if current_user != @comment.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end

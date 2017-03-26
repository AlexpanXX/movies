class FilmsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_film_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @films = Film.all
  end

  def show
    @film = Film.find(params[:id])
    @comments = @film.comments.recent.paginate( page: params[:page], per_page: 5)
  end

  def new
    @film = Film.new
  end

  def edit
  end

  def create
    @film = Film.new(film_params)
    @film.user = current_user

    if @film.save
      redirect_to films_path
    else
      render :new
    end
  end

  def update
    if @film.update(film_params)
      redirect_to films_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @film.destroy
    redirect_to films_path, alert: "Movie deleted"
  end

  def favorite
    @film = Film.find(params[:id])
    if !current_user.is_follower_of?(@film)
      current_user.favorite!(@film)
      flash[:notice] = "收藏电影成功！"
    else
      flash[:warning] = "你已经收藏过这部电影！"
    end
    redirect_to film_path(@film)
  end

  def dislikes
    @film = Film.find(params[:id])
    if current_user.is_follower_of?(@film)
      current_user.dislikes!(@film)
      flash[:alert] = "已取消收藏电影！"
    else
      flash[:warning] = "你没有收藏这部电影，怎么取消 XD"
    end
    redirect_to film_path(@film)
  end

  private

  def find_film_and_check_permission
    @film = Film.find(params[:id])
    if current_user != @film.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def film_params
    params.require(:film).permit(:title, :description)
  end
end

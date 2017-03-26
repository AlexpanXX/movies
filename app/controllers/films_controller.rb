class FilmsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_film_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @films = Film.all
  end

  def show
    @film = Film.find(params[:id])
    @comments = @film.comments
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

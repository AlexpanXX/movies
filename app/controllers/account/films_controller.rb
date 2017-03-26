class Account::FilmsController < ApplicationController
  before_action :authenticate_user!

  def index
    @films = current_user.favorited_films
  end
end

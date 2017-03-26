class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :films
  has_many :film_relationships
  has_many :favorited_films, through: :film_relationships, source: :film

  def is_follower_of?(film)
    favorited_films.include?(film)
  end

  def favorite!(film)
    favorited_films << film
  end

  def dislikes!(film)
    favorited_films.delete(film)
  end
end

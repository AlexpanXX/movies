class Film < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :film_relationships
  has_many :followers, through: :film_relationships, source: :user
end

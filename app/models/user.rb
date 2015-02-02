class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { in: 3..15 }

  validates :password, length: { minimum: 4 }

  validates :password, format: { with: /[A-Z].*\d|\d.*[A-Z]/,  message: "has to contain one number and one upper case letter" }

end

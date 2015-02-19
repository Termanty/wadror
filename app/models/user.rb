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

  def self.top(n)
    sorted_by_most_ratings = User.all.sort_by{ |u| -(u.ratings.count) }
    sorted_by_most_ratings.take(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
   #max_rating (ratings.map { |r| [r.style, r.score]})
  end

  def favorite_brewery

  end

end

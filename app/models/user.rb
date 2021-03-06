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

  def favorite_brewery
    return nil if ratings.empty?
    brewery_ratings = rated_breweries.inject([]) do |ratings, brewery|
      ratings << {
          name: brewery,
          rating: rating_of_brewery(brewery) }
    end

    brewery_ratings.sort_by { |brewery| brewery[:rating] }.reverse.first[:name]
  end

  def favorite_style_name
    fs = favorite_style
    return '' if fs.nil?
    fs.name
  end

  def favorite_brewery_name
    fb = favorite_brewery
    return '' if fb.nil?
    fb.name
  end

  def favorite_style
    return nil if ratings.empty?
    style_ratings = rated_styles.inject([]) do |ratings, style|
      ratings << {
          name: style,
          rating: rating_of_style(style) }
    end

    style_ratings.sort_by { |style| style[:rating] }.reverse.first[:name]
  end

  def rated_breweries
    ratings.map{ |r| r.beer.brewery }.uniq
  end

  def rated_styles
    ratings.map{ |r| r.beer.style }.uniq
  end

  def rating_of_brewery(brewery)
    ratings_of_brewery = ratings.select do |r|
      r.beer.brewery == brewery
    end
    ratings_of_brewery.map(&:score).sum / ratings_of_brewery.count
  end

  def rating_of_style(style)
    ratings_of_style = ratings.select do |r|
      r.beer.style == style
    end
    ratings_of_style.map(&:score).sum / ratings_of_style.count
  end


end

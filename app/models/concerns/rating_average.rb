module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    self.rating.average(:score)
  end
end
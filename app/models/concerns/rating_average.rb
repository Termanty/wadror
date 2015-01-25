module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    #self.rating.average(:score)
    "5"
  end
end
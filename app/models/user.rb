class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true, length: { minimum: 3,  maximum: 15 }

  has_many :ratings ,numericality: { greater_than_or_equal_to: 1024,
                                    less_than_or_equal_to: ->(_){Time.now.year} }


end

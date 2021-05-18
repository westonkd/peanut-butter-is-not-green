# frozen_string_literal: true

require_relative './peanut_model'

class PeanutButter < PeanutModel
  attributes %i[
    brand
    price_per_ounce
    average_rating
    color
  ]
end

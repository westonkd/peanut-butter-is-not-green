# frozen_string_literal: true

require_relative './peanut_model'

class User < PeanutModel
  attributes %i[
    is_admin
    given_names
    surnames
  ]

  def full_name
    "#{given_names} #{surnames}"
  end
end

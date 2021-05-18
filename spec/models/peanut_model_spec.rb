# frozen_string_literal: true

require 'ostruct'
require 'rspec'

require_relative '../../app/models/user'

module Models
  describe PeanutModel do
    User.create!(
      given_names: 'Weston Kody',
      surnames: 'Dransfield'
    )
  end
end

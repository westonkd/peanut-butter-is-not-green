# frozen_string_literal: true

require 'ostruct'

class PeanutController
  attr_reader :params, :current_user

  def initialize(user:, params:)
    @current_user = user
    @params = params
  end

  def render(status:, json: nil)
    OpenStruct.new(code: status, body: json)
  end
end

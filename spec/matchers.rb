# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :respond_with do |expected|
  match do |actual|
    actual.code == expected
  end
end

RSpec::Matchers.define :be_ok do |expected|
  match do |actual|
    actual.code == 200
  end
end

RSpec::Matchers.define :be_not_found do |expected|
  match do |actual|
    actual.code == 404
  end
end

RSpec::Matchers.define :be_unauthorized do |expected|
  match do |actual|
    actual.code == 401
  end
end
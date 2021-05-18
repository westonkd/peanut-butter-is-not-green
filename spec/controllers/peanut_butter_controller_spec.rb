# frozen_string_literal: true

require 'ostruct'
require 'rspec'

require_relative '../../app/controllers/peanut_butter_controller'
require_relative '../../app/models/peanut_butter'

describe PeanutButterController do
  it 'shows the requested peanut butter with status 200 when it exists' do
    pb = PeanutButter.create!(
      brand: 'Jif',
      price_per_ounce: 13.8,
      average_rating: 3.5,
      color: 'not green'
    )

    response = PeanutButterController.new({}, { id: pb.id }).show
    expect(response.code).to eq 200
    expect(response.body[:brand]).to eq 'Jif'
    expect(response.body[:price_per_ounce]).to eq 13.8
    expect(response.body[:average_rating]).to eq 3.5
    expect(response.body[:color]).to eq 'not green'
  end

  it 'renders 404 and an error message if the peanut butter does not exist' do
    response = PeanutButterController.new({}, { id: 999 }).show
    expect(response.code).to eq 404
    expect(response.body[:message]).to eq 'A record with the given ID does not exist'
  end
end


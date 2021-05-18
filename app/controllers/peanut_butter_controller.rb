# frozen_string_literal: true

require_relative './peanut_controller'
require_relative '../../config/peanut_store'
require_relative '../models/peanut_butter'

class PeanutButterController < PeanutController
  def show
    render json: PeanutButter.find(params[:id]).as_json, status: 200
  rescue PeanutStore::RecordNotFound
    render json: { message: 'A record with the given ID does not exist' }, status: 404
  end

  def index
  end

  def update
  end

  def destroy
  end
end
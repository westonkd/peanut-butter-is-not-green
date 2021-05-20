# frozen_string_literal: true

require_relative './peanut_controller'
require_relative '../../config/peanut_store'
require_relative '../models/peanut_butter'

require 'byebug'

class PeanutButterController < PeanutController
  def show
    return render_user_required unless @current_user

    render json: peanut_butter.as_json, status: 200
  rescue PeanutStore::RecordNotFound
    render_not_found
  end

  def update
    return render_user_required unless @current_user

    peanut_butter.update!(params[:peanut_butter])
    render json: peanut_butter.as_json, status: 200
  rescue PeanutStore::RecordNotFound
    render_not_found
  end

  # Who would ever want to destroy peanut butter? ;)
  # def destroy
  # end

  private

  def peanut_butter
    @peanut_butter ||= PeanutButter.find(params[:id])
  end

  def render_not_found
    render json: { message: 'A record with the given ID does not exist' }, status: 404
  end

  def render_user_required
    render json: { message: 'Requires an active user session' }, status: 401
  end
end

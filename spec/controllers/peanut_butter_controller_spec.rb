# frozen_string_literal: true

require_relative '../spec_helper'

describe PeanutButterController do
  let(:pb) do
    PeanutButter.create!(
      brand: 'Jif',
      price_per_ounce: 13.8,
      average_rating: 3.5,
      color: 'not green'
    )
  end

  let(:user) do
    User.create!(
      given_names: 'Weston K.',
      surnames: 'Dransfield'
    )
  end

  describe '#show' do
    context 'when the peanut butter exists' do
      it 'responds with status 200' do
        response = PeanutButterController.new(
          user: user, params: { id: pb.id }
        ).show

        expect(response).to be_ok
      end

      it 'responds with the requested peanut butter' do
        response = PeanutButterController.new(
          user: user, params: { id: pb.id }
        ).show

        expect(response.body).to include pb.to_h
      end
    end

    context 'when no user session exists' do
      it 'renders 401' do
        response = PeanutButterController.new(
          user: nil, params: { id: pb.id }
        ).show

        expect(response).to be_unauthorized
      end

      it 'includes an "unauthorized" message' do
        response = PeanutButterController.new(
          user: nil, params: { id: pb.id }
        ).show

        expect(response.body[:message]).to eq 'Requires an active user session'
      end
    end

    context 'when the peanut butter does not exist' do
      it 'renders 404' do
        response = PeanutButterController.new(user: user, params: { id: 999 }).show
        expect(response).to be_not_found
        expect(response.body[:message]).to eq 'A record with the given ID does not exist'
      end
    end
  end

  describe '#update' do
    context 'when the peanut butter exists' do
      let(:user) do
        User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield',
          is_admin: true
        )
      end

      it 'updates the peanut butter' do
        PeanutButterController.new(
          user: user,
          params: {
            id: pb.id,
            peanut_butter: {
              average_rating: 5.0
            }
          }
        ).update

        expect(PeanutButter.find(pb.id).average_rating).to eq 5
      end

      it 'responds with the updated peanut butter' do
        response = PeanutButterController.new(
          user: user,
          params: {
            id: pb.id,
            peanut_butter: {
              average_rating: 5.0
            }
          }
        ).update

        expect(response).to be_ok
        expect(response.body[:average_rating]).to eq 5.0
      end
    end

    context 'when the current user is not an admin' do
      it 'does not allow updating PB' do
        response = PeanutButterController.new(
          user: user,
          params: {
            id: pb.id,
            peanut_butter: {
              average_rating: 5.0
            }
          }
        ).update

        expect(response).to be_unauthorized
      end
    end

    context 'when no user session exists' do
      it 'responds with 401' do
        response = PeanutButterController.new(
          user: nil,
          params: {
            id: pb.id,
            peanut_butter: {
              average_rating: 5.0
            }
          }
        ).update

        expect(response).to be_unauthorized
      end
    end
  end
end

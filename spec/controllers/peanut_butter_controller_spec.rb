# frozen_string_literal: true

require_relative '../spec_helper'

describe PeanutButterController do
  describe '#show' do
    context 'when the peanut butter exists' do
      it 'shows the peanut butter with status 200' do
        user = User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield'
        )

        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

        response = PeanutButterController.new(
          user: user, params: { id: pb.id }
        ).show

        expect(response).to be_ok
        expect(response.body[:brand]).to eq 'Jif'
        expect(response.body[:price_per_ounce]).to eq 13.8
        expect(response.body[:average_rating]).to eq 3.5
        expect(response.body[:color]).to eq 'not green'
      end
    end

    context 'when no user session exists' do
      it 'renders 401' do
        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

        response = PeanutButterController.new(
          user: nil, params: { id: pb.id }
        ).show

        expect(response).to be_unauthorized
        expect(response.body[:message]).to eq 'Requires an active user session'
      end
    end

    context 'when the peanut butter does not exist' do
      it 'renders 404' do
        user = User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield'
        )

        response = PeanutButterController.new(user: user, params: { id: 999 }).show
        expect(response).to be_not_found
        expect(response.body[:message]).to eq 'A record with the given ID does not exist'
      end
    end
  end

  describe '#update' do
    context 'when the peanut butter exists' do
      it 'updates the peanut butter' do
        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

        user = User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield',
          is_admin: true
        )

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
        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

        user = User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield',
          is_admin: true
        )

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
        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

        user = User.create!(
          given_names: 'Weston K.',
          surnames: 'Dransfield',
        )

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
        pb = PeanutButter.create!(
          brand: 'Jif',
          price_per_ounce: 13.8,
          average_rating: 3.5,
          color: 'not green'
        )

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

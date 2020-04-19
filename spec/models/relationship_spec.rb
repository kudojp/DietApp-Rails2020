require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:rel) { build(:relationship, follower: create(:user), followed: create(:user, email: 'another@test.com', account_id: 'another')) }

  describe 'FacrtoryBot' do
    it 'instantiates valid relationship model' do
      expect(rel).to be_valid
    end
  end

  describe 'validation' do
    it 'is invalid without follwer_id' do
      rel.follower = nil
      rel.valid?
      expect(rel.errors[:follower_id]).to include("can't be blank")
    end

    it 'is invalid without followed_id' do
      rel.followed = nil
      rel.valid?
      expect(rel.errors[:followed_id]).to include("can't be blank")
    end

    it 'is invalid when duplicated model exists' do
      rel.save
      another_rel = build(:relationship, follower_id: rel[:follower_id], followed_id: rel[:followed_id])
      another_rel.valid?
      expect(another_rel.errors[:follower_id]).to include('has already been taken')
    end

    it 'is invalid to follow self account' do
      rel.followed = rel.follower
      rel.save
      expect(rel.errors[:relationship]).to include('cannot follow self account')
    end
  end
end

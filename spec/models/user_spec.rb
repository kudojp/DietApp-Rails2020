require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'FactoryBot' do
    it 'instantiate valid model with email, account_id, name, password' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'validation' do
    it 'is invalid without email' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without account' do
      user = build(:user, account_id: nil)
      user.valid?
      expect(user.errors[:account_id]).to include("can't be blank")
    end

    it 'is invalid without name' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without password' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid to exist duplicated account_ids' do
      user = create(:user)
      another_user = build(:user, email: 'anothertest@test.com')
      another_user.valid?
      expect(another_user.errors[:account_id]).to include('has already been taken')
    end

    it 'is invalid to exist duplicated names' do
      user = create(:user)
      another_user = build(:user, account_id: 'anothertesttest')
      another_user.valid?
      expect(another_user.errors[:email]).to include('has already been taken')
    end

    it 'should be certain that account_id consists 5-15 letters' do
      user = build(:user, account_id: 'a' * 4)
      user.valid?
      expect(user.errors[:account_id]).to include('is too short (minimum is 5 characters)')

      user = build(:user, account_id: ' ' + 'a' * 4 + ' ')
      user.valid?
      expect(user.errors[:account_id]).to include('is too short (minimum is 5 characters)')

      user = build(:user, account_id: 'a' * 5)
      user.valid?
      expect(user).to be_valid

      user = build(:user, account_id: 'a' * 15)
      user.valid?
      expect(user).to be_valid

      user = build(:user, account_id: ' ' + 'a' * 15 + ' ')
      user.valid?
      expect(user).to be_valid

      user = build(:user, account_id: 'a' * 16)
      user.valid?
      expect(user.errors[:account_id]).to include('is too long (maximum is 15 characters)')
    end

    it 'should be creatain that account_id consists only alphanumeric letters' do
      user = build(:user, account_id: '123あいう')
      user.valid?
      expect(user.errors[:account_id]).to include('should be alphanumeric')

      user = build(:user, account_id: 'password!')
      user.valid?
      expect(user.errors[:account_id]).to include('should be alphanumeric')
    end

    it 'should be certain that name consists 1-20 except surrounding spaces' do
      user = build(:user, name: ' ')
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")

      user = build(:user, name: '')
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")

      user = build(:user, name: 'a' * 1)
      user.valid?
      expect(user).to be_valid

      user = build(:user, name: 'a' * 20)
      user.valid?
      expect(user).to be_valid

      user = build(:user, name: ' ' + 'a' * 20 + ' ')
      user.valid?
      expect(user).to be_valid

      user = build(:user, name: 'a' * 21)
      user.valid?
      expect(user.errors[:name]).to include('is too long (maximum is 20 characters)')
    end
  end

  describe '#follow(user)/#unfollow(user)' do
    it 'creates/destroys relationship in Realtionhsips table' do
      user = create(:user)
      another = create(:user, email: 'another@test.test', account_id: 'another')

      # follow
      user.follow(another)
      expect(Relationship.where(follower_id: user.id, followed_id: another.id)).to exist

      # unfollow
      user.unfollow(another)
      expect(Relationship.where(follower_id: user.id, followed_id: another.id)).not_to exist
    end
  end

  describe '#following?(user)' do
    it 'returns array of following' do
      user = create(:user)
      another = create(:user, email: 'another@test.test', account_id: 'another')
      user.follow(another)

      expect(user.following?(another)).to be_truthy
    end
  end

  describe '#meal_posts_feed' do
    # TODO
  end
end

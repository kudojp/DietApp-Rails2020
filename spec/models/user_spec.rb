require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'is valid with email, account_id, name, password' do
      user = build(:user)
      expect(user).to be_valid
    end

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

  describe '#follow(user)' do
  end

  describe '#unfollow(user)' do
  end

  describe '#following?(user)' do
  end

  describe '#meal_posts_feed' do
  end

  # it 'is possible to follow another user' do
  # end

  # it 'is posssible to unfollow another user' do
  # end

  # it 'is possible to get an array of following users' do
  # end

  # it 'is possible to check whether a user is following another user' do
  # end

  # it 'is possible to get meal_posts_feed (an array of all meal_posts followed by a user)' do
  # end
end

# account_id should be unique, 5-15? 英数
# name should be unique, 1-20, 英数平仮名
# follow(other_user)
# followings()
# unfollow(other_user)
# following?(other_user)
# meal_posts_feed¥

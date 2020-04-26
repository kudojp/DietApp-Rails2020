require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:vote) { create(:vote) }
  let(:meal_post) { create(:meal_post) }

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

    it 'is invalid to exist duplicated emails' do
      user.email = 'duplicated@test.com'
      user.save
      another_user = build(:user, email: 'duplicated@test.com')
      another_user.valid?
      expect(another_user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid to exist duplicated account_ids' do
      user.account_id = 'duplicated'
      user.save
      another_user = build(:user, account_id: 'duplicated')
      another_user.valid?
      expect(another_user.errors[:account_id]).to include('has already been taken')
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
      another = create(:user, email: 'another@test.test', account_id: 'another')
      user.follow(another)

      expect(user.following?(another)).to be_truthy
    end
  end

  describe '#meal_posts_feed' do
    it 'returns meal_posts posted by followitng users in the correct order' do
      followed_user = create(:user)
      not_followed_user = create(:user)

      followed_old_post = create(:meal_post, user: followed_user, time: '2010/04/14 21:45:22')
      followed_mid_post = create(:meal_post, user: followed_user, time: '2012/04/14 21:45:22')
      followed_new_post = create(:meal_post, user: followed_user, time: '2014/04/14 21:45:22')

      not_followed_old_post = create(:meal_post, user: not_followed_user, time: '2011/04/14 21:45:22')
      not_followed_mid_post = create(:meal_post, user: not_followed_user, time: '2013/04/14 21:45:22')
      not_followed_new_post = create(:meal_post, user: not_followed_user, time: '2015/04/14 21:45:22')

      user.follow(followed_user)
      posts_feed = user.meal_posts_feed

      expect(posts_feed.size).to be(3)
      expect(posts_feed[0]).to eq(followed_new_post)
      expect(posts_feed[1]).to eq(followed_mid_post)
      expect(posts_feed[2]).to eq(followed_old_post)
    end
  end

  describe '#voted?' do
    it 'returns true if is_upvote=true is given when current user has alredy upvoted to given meal_post' do
      vote.meal_post = meal_post
      vote.user = user
      vote.save
      expect(user.voted?(true, meal_post)).to be_truthy
      expect(user.voted?(false, meal_post)).to be_falsey
    end

    it 'returns true if is_upvote=false is given when current user has already downvoted to given meal_post' do
      vote.meal_post = meal_post
      vote.user = user
      vote.is_upvote = false
      vote.save
      expect(user.voted?(false, meal_post)).to be_truthy
      expect(user.voted?(true, meal_post)).to be_falsey
    end

    it 'returns false when current user has not voted to given meal_post' do
      expect(user.voted?(true, vote)).to be_falsey
      expect(user.voted?(false, vote)).to be_falsey
    end
  end

  describe '#change_vote_state' do
    it 'changes state to upvoted: push upvote when not voted' do
      returned_vote = user.change_vote_state(true, meal_post)
      expected_attributes = { user: user, meal_post: meal_post, is_upvote: true }

      expect(Vote.where(user: user, meal_post: meal_post, is_upvote: true)).to exist
      expect(returned_vote).to have_attributes(expected_attributes)
    end

    it 'changes state to downvoted: push downvote when not voted' do
      returned_vote = user.change_vote_state(false, meal_post)
      expected_attributes = { user: user, meal_post: meal_post, is_upvote: false }

      expect(Vote.where(user: user, meal_post: meal_post, is_upvote: false)).to exist
      expect(returned_vote).to have_attributes(expected_attributes)
    end

    it 'change state to not voted: push upvote when upvoted ' do
      vote.user = user
      vote.meal_post = meal_post
      vote.is_upvote = true
      vote.save

      returned_vote = user.change_vote_state(true, meal_post)

      expect(Vote.where(user: user, meal_post: meal_post)).to be_empty
      expect(returned_vote).to be_nil
    end

    it 'changes state to downvoted: push downvote when upvoted' do
      vote.user = user
      vote.meal_post = meal_post
      vote.is_upvote = true
      vote.save

      returned_vote = user.change_vote_state(false, meal_post)
      expected_attributes = { user: user, meal_post: meal_post, is_upvote: false }

      expect(Vote.where(user: user, meal_post: meal_post, is_upvote: false)).to exist
      expect(returned_vote).to have_attributes(expected_attributes)
    end

    it 'changes state to upvoted: push upvote when downvoted' do
      vote.user = user
      vote.meal_post = meal_post
      vote.is_upvote = false
      vote.save

      returned_vote = user.change_vote_state(true, meal_post)
      expected_attributes = { user: user, meal_post: meal_post, is_upvote: true }

      expect(Vote.where(user: user, meal_post: meal_post, is_upvote: true)).to exist
      expect(returned_vote).to have_attributes(expected_attributes)
    end

    it 'change state to not voted: push downvote when downvoted ' do
      vote.user = user
      vote.meal_post = meal_post
      vote.is_upvote = false
      vote.save

      returned_vote = user.change_vote_state(false, meal_post)

      expected_attributes = { user: user, meal_post: meal_post, is_upvote: false }
      expect(Vote.where(user: user, meal_post: meal_post)).to be_empty
      expect(returned_vote).to be_nil
    end
  end

  describe 'has_many :(un)favorite meal_posts association' do
    it 'returns (un)favorite meal posts properly' do
      good_mp1 = create(:meal_post)
      good_mp2 = create(:meal_post)
      bad_mp1 = create(:meal_post)
      bad_mp2 = create(:meal_post)

      upvote1 = Vote.create(user: user, meal_post: good_mp1, is_upvote: true)
      upvote2 = Vote.create(user: user, meal_post: good_mp2, is_upvote: true)
      downvote1 = Vote.create(user: user, meal_post: bad_mp1, is_upvote: false)
      downvote2 = Vote.create(user: user, meal_post: bad_mp2, is_upvote: false)

      expect(user.upvotes).to match_array([upvote1, upvote2])
      expect(user.favorite_meal_posts).to match_array([good_mp1, good_mp2])

      expect(user.unfavorite_meal_posts).to match_array([bad_mp1, bad_mp2])
      expect(user.downvotes).to match_array([downvote1, downvote2])
    end
  end
end

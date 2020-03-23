require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UserHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UserHelper, type: :helper do
  let(:user) { create(:user) }
  describe '#show_sex' do
    context 'sex has not been registered' do
      it 'returns nil' do
        expect(helper.show_sex(user)).to be_nil
      end

      context 'sex has been registered' do
        it 'returns the sex with label' do
          # male
          user.is_male = true
          user.save
          expect(helper.show_sex(user)).to eql('Sex: Male')
          # female
          user.is_male = false
          user.save
          expect(helper.show_sex(user)).to eql('Sex: Female')
        end
      end
    end
  end

  describe '#show_height' do
    context 'height has not been registered' do
      it 'returns nil' do
        expect(helper.show_height(user)).to be_nil
      end

      context 'height has been registered' do
        it 'returns the height with label' do
          user.height = 150.5
          user.save
          expect(helper.show_height(user)).to eql('Height: 150.5')
        end
      end
    end
  end

  describe '#show_weight' do
    context 'weight has not been registered' do
      it 'returns nil' do
        expect(helper.show_weight(user)).to be_nil
      end

      context 'weight has been registered' do
        it 'returns the weight with label' do
          user.weight = 50.5
          user.save
          expect(helper.show_weight(user)).to eql('Weight: 50.5')
        end
      end
    end
  end

  describe '#show_comment' do
    context 'comment has not been registered' do
      it 'returns nil' do
        expect(helper.show_comment(user)).to be_nil
      end

      context 'Comment has been registered' do
        it 'returns the Comment with label' do
          user.comment = 'I wanna lose weight.'
          user.save
          expect(helper.show_comment(user)).to eql('Comment: I wanna lose weight.')
        end
      end
    end
  end
end

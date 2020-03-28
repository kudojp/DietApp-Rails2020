module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.find_from_omniauth(request.env['omniauth.auth'])

      if @user
        sign_in_and_redirect @user
        set_flash_message(:noteice, :success, kind: 'Facebook') if is_navigational_format?
      else
        facebook_data = request.env['omniauth.auth']
        session['devise.facebook'] = facebook_data
        @user = User.new
        @user.email = facebook_data['extra']['raw_info'].email
        @user.name = facebook_data['extra']['raw_info'].name
        render 'devise/registrations/new_after_facebook_auth'
      end
    end

    def failure
      redirect_to root_path
    end
  end
end

class FacebookForm
  include ActiveModel::Model
  attr_accessor :account_id
  validates :account_id, presence: true, length: { in: 5..15 },
                         format: { with: /\A[A-Za-z0-9]+\z/, message: 'should be alphanumeric' }
end

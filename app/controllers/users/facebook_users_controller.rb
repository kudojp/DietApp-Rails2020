module Users
  class FacebookUsersController < ApplicationController
    def create
      # Signing up from this controller allows password to be nil
      redirect_to new_user_registration_path, alert: 'Something is wrong with facebook oauth' if session['devise.facebook'].nil?
      @f_user = User.new(facebook_user_params.merge(provider: session['devise.facebook']['provider'], uid: session['devise.facebook']['uid']))
      @f_user.is_registrable_without_password = true
      return sign_in_and_redirect @f_user if @f_user.save

      render 'devise/registrations/new_after_facebook_auth'
    end

    private

    def facebook_user_params
      params.require(:user).permit(:account_id, :email, :name)
    end
  end
end

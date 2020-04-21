module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # Find a user from auth hash
      @f_user = User.find_from_omniauth(request.env['omniauth.auth'])

      if @f_user
        sign_in_and_redirect @f_user
        set_flash_message(:noteice, :success, kind: 'Facebook') if is_navigational_format?
      else
        facebook_data = request.env['omniauth.auth']
        session['devise.facebook'] = facebook_data
        @f_user = User.new
        @f_user.email = facebook_data['extra']['raw_info'].email
        @f_user.name = facebook_data['extra']['raw_info'].name
        render 'devise/registrations/new_after_facebook_auth'
      end
    end

    def failure
      redirect_to root_path
    end
  end
end

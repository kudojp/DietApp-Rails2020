module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # Find a user from auth hash
      @f_user = User.find_from_omniauth(request.env['omniauth.auth'])

      if @f_user
        sign_in_and_redirect @f_user
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        facebook_data = request.env['omniauth.auth']
                               .tap { |fd| session['devise.facebook'] = fd }
        @f_user = User.new.tap do |u|
          u.email = facebook_data['extra']['raw_info'].email
          u.name = facebook_data['extra']['raw_info'].name
        end

        render 'devise/registrations/new_after_facebook_auth'
      end
    end

    def failure
      redirect_to root_path
    end
  end
end

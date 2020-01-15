# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    protect_from_forgery except: [:cognito_idp]

    def cognito_idp
      callback
    end

    def callback
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message :notice, :signed_in
      else
        # session['devise.cognito_idp_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
end

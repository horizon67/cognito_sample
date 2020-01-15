# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery except: [:aws_auth]
  before_action :restrict_access, only: [:aws_auth]

  def aws_auth
    defaults = {
      id: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      authentication_hash: nil
    }
    user = User.where(email: aws_auth_params[:email]).first

    if user
      answer = user.as_json(only: defaults.keys)
      answer[:user_exists] = true
      answer[:success] = user.valid_password?(aws_auth_params[:password])
    else
      answer = defaults
      answer[:success] = false
      answer[:user_exists] = false
    end

    respond_to do |format|
      format.json { render json: answer }
    end
  end

  private

  def restrict_access
    head :unauthorized unless params[:access_token] == ENV['TOKEN']
  end

  def aws_auth_params
    params.permit(:email, :password)
  end
end

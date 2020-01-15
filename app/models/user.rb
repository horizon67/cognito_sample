# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: [:cognito_idp]

  def self.from_omniauth(auth)
    user = find_or_initialize_by(email: auth.info.email)
    user.uid ||= auth.uid
    user.password ||= Devise.friendly_token[0, 20]
    user.save!
    user
  end
end

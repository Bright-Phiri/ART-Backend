# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: email_address_with_name(Rails.application.credentials.sys_email, 'ART Team')

  def password_reset
    @user = params[:user]
    mail(to: email_address_with_name(@user.email, @user.username), subject: 'Reset your account password')
  end
end

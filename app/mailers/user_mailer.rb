class UserMailer < ApplicationMailer
    default from: email_address_with_name('mail', 'ART Team')

    def password_reset 
        @user = params[:user]
        mail(to: @user.email, subject: 'Reset your account password')
    end

end

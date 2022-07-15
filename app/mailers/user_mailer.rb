class UserMailer < ApplicationMailer
    default from: email_address_with_name('bphiri1998@gmail.com', 'ART Team')

    def password_reset 
        @user = params[:user]
        mail(to: @user.email, subject: 'Reset your account password')
    end

end

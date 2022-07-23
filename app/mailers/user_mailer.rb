class UserMailer < ApplicationMailer
    default from: email_address_with_name('bphiri.aki@gmail.com', 'ART Team')

    def password_reset 
        @user = params[:user]
        mail(to: 'bphiri1998@gmail.com', subject: 'Reset your account password')
    end

end

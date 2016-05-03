class UserMailer < ApplicationMailer
    default from: 'password_reset@timesheet.apoyar.eu'
    def reset_email(email, user, password)
        @user=user
        @password=password
        mail(to: email, subject: "Password reset for timesheet.apoyar.eu")
    end
end

class UserMailer < ApplicationMailer
    default from: 'noreply@timesheet.apoyar.eu'
    def reset_email(email, user, password)
        @user=user
        @password=password
        mail(to: email, subject: "Testing")
    end
end

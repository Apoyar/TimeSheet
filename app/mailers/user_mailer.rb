class UserMailer < ApplicationMailer
    default from: 'noreply@timesheet.apoyar.eu'
    def reset_email(email, user, password)
        @user=user
        @password=password
        mail(to: email, subject: "Password reset for timesheet.apoyar.eu")
    end
    def new_notification(email, user, password)
        @user=user
        @password=password
        mail(to: email, subject: "Invitation to timesheet.apoyar.eu")
    end
end

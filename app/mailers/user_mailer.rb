class UserMailer < ApplicationMailer
    default from: 'relay@apoyar.eu'
    def reset_email(email, user, password)
        @user=user
        @password=password
        mail(to: email, subject: "Password reset for timesheet.apoyar.eu")
    end
end

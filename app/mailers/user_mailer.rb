class UserMailer < ApplicationMailer
    default from: "noreply@timesheet.apoyar.com"
    def reset_email(email)
        mail(to: email, subject: "Testing")
    end
end

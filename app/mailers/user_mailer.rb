class UserMailer < ApplicationMailer
    default from: "noreply@timesheet.apoyar.eu"
    def reset_email(email)
        mail(to: email, subject: "Testing")
    end
end

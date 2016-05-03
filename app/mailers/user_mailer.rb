class UserMailer < ApplicationMailer
    default_from: 'noreply@timesheet.apoyar.eu'
    def reset_email(email)
        mail(to: email, subject: "Testing")
    end
end

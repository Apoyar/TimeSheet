class UserMailer < ApplicationMailer
    default from: "noreply@timesheet.apoyar.net"
    def reset_email(email)
        mail(to: email, subject: "Testing")
    end
end

class UserMailer < ApplicationMailer
    default from: "relay@apoyar.net"
    def reset_email(email)
        mail(to: email, subject: "Testing")
    end
end

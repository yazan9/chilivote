class PasswordMailer < ActionMailer::Base
  default from: "admin@chilivote.com"
  def reset_password(email, code)
    @code = code
    mail(to: email, subject: "Your new password for Chilivote.com")
  end
end

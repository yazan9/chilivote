class UserMailer < ActionMailer::Base
  default from: "admin@chilivote.com"
  def welcome_email(email, code)
    @code = code
    mail(to: email, subject: "Your Chilivote Registration Code")
  end
end

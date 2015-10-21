class UserMailer < ActionMailer::Base
  default from: "yazan.khalaileh@gmail.com"
  def welcome_email(email)
    mail(to: email, subject: "Your Chilivote Registration Code")
  end
end

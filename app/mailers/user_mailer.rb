class UserMailer < ActionMailer::Base
  default from: "yazan.khalaileh@gmail.com"
  def welcome_email
    mail(to: "yazan.khalaileh@gmail.com", subject: "Helloy there")
  end
end

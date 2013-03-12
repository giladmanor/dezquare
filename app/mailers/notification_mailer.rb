class NotificationMailer < ActionMailer::Base
  default from: "hello@dezqure.com"
  default to: "ronen@dezquare.com"
  
  def new_message(message)
    @message = message
    mail(:subject => "[Dezqaure] New contact message!")
  end
end

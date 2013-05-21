class NotificationMailer < ActionMailer::Base
  default from: "hello@dezquare.com"
  default to: "ronen@dezquare.com"
  
   def new_message(message)
     @message = message
     mail(:subject => "[Dezqaure] New contact message!")
   end
  
  def new_project(project)
    @project = project
    mail(:subject => "[Dezqaure] New Project Alert!")
  end
  
  def accepted_project(project)
    @project = project
    mail(:subject => "[Dezquare] Accepted Project Alert!")
  end
end

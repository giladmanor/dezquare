class NotificationMailer < ActionMailer::Base
  default from: "hello@dscovered.com"
  default to: "ronen@dscovered.com"
  
   def new_message(message)
     @message = message
     mail(:subject => "[dscovered] New contact message!")
   end
  
  def new_project(project)
    @project = project
    mail(:subject => "[dscovered] New Project Alert!")
  end
  
  def accepted_project(project)
    @project = project
    mail(:subject => "[dscovered] Accepted Project Alert!")
  end
end

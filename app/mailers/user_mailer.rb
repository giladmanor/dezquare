class UserMailer < ActionMailer::Base
  default from: "hello@dezquare.com"
  
  def designer_welcome(user)
    @user = user
    mail(:to => @user.email,:subject => "Youre now part of the dezquare gang")
  end
  
  def shopper_complete_game(user)
    @user = user
    mail(:to => @user.email,:subject => "Your design will kick off soon")
  end
  
  def designer_new_match(user)
    @user = user
    mail(:to => @user.email,:subject => "New Matched Customer!")
  end
  #
  def pender_complete_request(user)
    @user = user
    mail(:to => @user.email,:subject => "So you want to be part of the gang")
  end
  
  def designer_send_password(user)
    @user = user
    mail(:to => @user.email,:subject => "Dezquare account access")
  end
  
end

class UserMailer < ActionMailer::Base
  default from: "hello@dezquare.com"
  
  
  def pender_complete_request(user)
    @user = user
    mail(:to => @user.email,:subject => "So you want to be part of the Dezquare gang")
  end
  
  def designer_welcome(user)
    @user = user
    mail(:to => @user.email,:subject => "Youre now part of the Dezquare gang")
  end
  
  def designer_send_password(user)
    @user = user
    mail(:to => @user.email,:subject => "Dezquare account access")
  end
  
  def designer_new_match(user)
    @user = user
    #mail(:to => @user.email,:subject => "New Matched Customer!")
    mail(:to => 'ronen@dezquare.com',:subject => "New Matched Customer!")
    
  end
  
  #----------------------------------------------------------------------------------
  
  def shopper_complete_registration(user)
    @user = user
    mail(:to => @user.email,:subject => "Welcome to Dezquare")
  end
  
  def shopper_complete_game(user)
    @user = user
    mail(:to => @user.email,:subject => "Your design will kick off soon on Dezquare")
  end
  
  def shopper_change_email(user)
    @user = user
    mail(:to => @user.email,:subject => "Email Confirmation for Dezquare")
  end
  
  
  def shopper_change_password(user)
    @user = user
    mail(:to => @user.email,:subject => "Password changed in Dezquare")
  end
  
  def shopper_send_password(user)
    @user = user
    mail(:to => @user.email,:subject => "New Password for Dezquare")
  end
  
  
  
end

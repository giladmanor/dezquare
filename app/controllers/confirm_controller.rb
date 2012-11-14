class ConfirmController < ApplicationController
  def email
    h = params[:id]
    uid=params[:u]
    
    user=User.find(uid)
    
    if user.confirm_email h
      session[:user_id] = user.id
    else 
      session[:user_id] = nil
    end
    redirect_to "/"
  end
  
  def abort
    h = params[:id]
    uid=params[:u]
    
    user=User.find(uid)
    
    user.create_password
    user.save
    UserMailer.designer_send_password(user).deliver
    session[:user_id] = nil
    
    redirect_to "/"
  end
end

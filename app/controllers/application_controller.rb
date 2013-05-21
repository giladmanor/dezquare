class ApplicationController < ActionController::Base
  #protect_from_forgery
  
def after_sign_in_path_for(resource)
    
    #if @user.present? && @user.shopper? #&& params[:controller]=="site" && params[:action]=="index"
    #  return 'site#dashboard'
    #end
    ##root_path    
    #current_user_path
   if @user.present? 
      if @user.shopper?
        "/site/dashboard" 
      elsif @user.designer?
        "/designer/dashboard"
      else
         current_user_path
      end   
   else
     current_user_path
   end
end  
  
end

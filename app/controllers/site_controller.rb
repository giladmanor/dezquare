class SiteController < ApplicationController
  
  def index
    
  end
  
  def login
    @user = User.find_by_email(params[:email])
    logger.debug "#{@user.inspect}"
    if !@user.nil? && @user.password==params[:password]
      session[:user_id]=@user.id
      logger.debug "##############################################################################################################"
      if @user.shopper
        
        redirect_to :action=>:dashboard
      else
        redirect_to :controller=>:designer,:action=>:dashboard  
      end
      
      return
    end
    #loc = request.referer.split('?')[0].split('/').reverse
    redirect_to :controller=>:pender, :action=>:register_designer,:state=>"login", :error=>"Wrong email or password"
  end
  
  
  
  
end

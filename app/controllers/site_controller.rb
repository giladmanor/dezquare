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
  
  
  def register_shopper
    logger.debug " creating a new shopper "
    user = User.new  
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    user.update_attributes(attr.except(:id))
    user.shopper=true
    logger.debug " shopper to save: #{user.inspect} "
    if user.save
      logger.debug " shopper saved with id:#{user.id} "
      UserMailer.pender_complete_request(user).deliver
      session[:user_id] = user.id
      redirect_to :controller=>:game,:action=>:index
    else
      logger.debug " found errors: #{user.errors.messages.values.join(', ')} "
      @error="#{user.errors.messages.values.join(', ')}"
      render "register_customer"
    end
    
  end
  
  
  
  
end

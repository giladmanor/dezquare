class SiteController < ApplicationController
  
  before_filter :load_user, :except=>[:login]
  before_filter :shopper_zone, :only => [:dashboard, :settings]
  
  def index
    
  end
  
  def login
    @user = User.find_by_email(params[:email])
    logger.debug "#{@user.inspect}"
    if !@user.nil? && @user.password==params[:password]
      session[:user_id]=@user.id
      logger.debug "##############################################################################################################"
      
      if params[:callback].nil?
        if @user.shopper 
          redirect_to :action=>:dashboard
        else
          redirect_to :controller=>:designer,:action=>:dashboard  
        end
        return  
      end
    end
    
    loc = request.referer.split('?')[0].split('/').reverse
    loc = ["index","site"] if loc[1]==""
    
    redirect_to :controller=>loc[1], :action=>loc[0],:state=>"login", :error=>"Wrong email or password"
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :action=>index
  end
  
  def dashboard
    @author = @user
    @editable=true
  end
  
  def settings
    @author = @user
    @editable=true
  end
  
  def shopper_zone
    redirect_to :action=>:index if @user.nil? || !@user.shopper
  end
  
  
  def load_user
    @user=User.find(session[:user_id]) unless session[:user_id].nil?
  end
  
end

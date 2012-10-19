class SiteController < ApplicationController
  
  before_filter  :load_user, :except=>[:login]
  before_filter :shopper_zone, :only => [:dashboard, :settings]
  
  DIR_PATH_AVATARS = "#{Rails.root}/public/user_avatars/"
  DIR_PATH_COVERS = "#{Rails.root}/public/user_covers/"
  
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
  
  def password_reminder
    user = User.find_by_email(params[:email])
    logger.debug "password recap for :#{user.inspect}"
    unless user.nil?
      UserMailer.designer_send_password(user).deliver
      logger.debug "password recap sent"
    end
    
    render :action=>:index
  end
  
  
  def dashboard
    @author = @user
    @editable=true
    
    redirect_to :controller=>:game, :action=>:index if @user.projects_out.length==0
    
  end
  
  def settings
    @author = @user
    @editable=true
    
    
  end
  
  def set_details
    @user.name = params[:name]
    @user.l_name=params[:l_name]
    @user.email=params[:email]
    
    
    if params[:old_password].present? && params[:new_password].present? && params[:repeat_new_password].present?
      if params[:new_password]==params[:repeat_new_password]
        @user.password=params[:new_password]
      else
        @error="PASSWORD"
      end
    end
    
    unless @user.save
      @error = @user.error.message
    end
    redirect_to :action=>:settings, :error=>@error
  end
  
  # profile images upload ------------------------------------------------------------
  
  def upload_avatar
    begin
      @user.set_avatar(params[:upload],DIR_PATH_AVATARS)
      flash[:notice] = "File has been uploaded successfully"
      #redirect_to :action => "profile"
      logger.debug "file upload success"
    rescue Exception => e
      flash[:error] = "Error with upload! Please retry."
      logger.debug "file upload failed"
      logger.debug "Error: #{e.inspect}"
    end
    
    loc = request.referer.split('?')[0].split('/').reverse
    redirect_to :controller=>loc[1], :action=>loc[0]
  end
  
  def upload_cover
    begin
      @user.set_cover(params[:upload],DIR_PATH_COVERS)
      flash[:notice] = "File has been uploaded successfully"
      #redirect_to :action => "profile"
      logger.debug "file upload success"
    rescue Exception => e
      flash[:error] = "Error with upload! Please retry."
      logger.debug "file upload failed"
      logger.debug "Error: #{e.inspect}"
    end
    loc = request.referer.split('?')[0].split('/').reverse
    redirect_to :controller=>loc[1], :action=>loc[0]
  end
  
  # filters ---------------------------------------------------------------------------
  
  def shopper_zone
    logger.debug "shopper_zone #{@user.inspect}"
    if @user.nil? 
      redirect_to :action=>:index
      return
    end
    
  end
  
  def load_user
    begin
      @user=User.find(session[:user_id]) unless session[:user_id].nil?
    rescue
      session[:user_id] = nil
    end
    logger.debug "loaded user: #{@user.full_name}" unless @user.nil?
    
    if !@user.nil? && @user.designer && params[:controller]=="site" && params[:action]=="index"
      redirect_to :controller=>:designer, :action=>:dashboard
    end
    
    
  end
    
end

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
    if !@user.nil? #&& @user.password?(params[:password]) && @user.email_confirm
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
    
    if @user.nil?
      redirect_to :controller=>loc[1], :action=>loc[0],:state=>"login", :error=>"Wrong email or password"
    elsif !@user.email_confirm
      redirect_to :controller=>:site, :action=>:index,:state=>"confirm", :error=>""
    else
      redirect_to :controller=>loc[1], :action=>loc[0],:state=>"login", :error=>"Wrong email or password"
    end
  end
  
  def resend_confirmation
    @user = User.find_by_email(params[:email])
    UserMailer.shopper_change_email(@user).deliver unless @user.nil?
    redirect_to :action=>:index
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :action=>:index
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
  
  
  def cancel_design
    project = Project.find(params[:id])
    project.canceled
    project.save
    redirect_to :action=>:dashboard
  end
  
  def complete_project
    project = Project.find(params[:id])
    project.completed
    project.save
    redirect_to :action=>:dashboard
  end
  
  def latest_designs
    @author=@user
  end
  
  def settings
    @author = @user
    @editable=true
    
    
  end
  
  def set_details
    @user.name = params[:name]
    @user.l_name=params[:l_name]
    logger.debug "===================================================================================="
    if @user.email!=params[:email]
      @user.email=params[:email]
      @user.email_confirm=false
      logger.debug "shopper_change_email"
      @send_email_change = true
    end
    logger.debug "===================================================================================="
    
    
    if params[:old_password].present? && params[:new_password].present? && params[:repeat_new_password].present?
      if params[:new_password]==params[:repeat_new_password] && @user.valid_password?(params[:old_password])
        @user.password=params[:new_password]
        pass_changed=1
        logger.debug "shopper_change_passwords"
        UserMailer.shopper_change_password(@user).deliver
      else
        @error="PASSWORD"
      end
    end
    
    unless @user.save
      @error = @user.error.message
    end
    
    
    
    if @error.nil?
      if pass_changed
        sign_in(current_user, :bypass => true)
        flash[:notice] = 'Password updated.'
      end
      UserMailer.shopper_change_email(@user).deliver if @send_email_change
      redirect_to :action=>:dashboard
      return
    end
    redirect_to :action=>:settings, :error=>@error
  end
  
  # contact-us form ------------------------------------------------------------------
  def contact
    @message = ContactMessage.new
  end
  
  def contact_sent
    if @user.present?
      params[:contact_message][:name] = @user.full_name
      params[:contact_message][:email] = @user.email
    end
    @message = ContactMessage.new(params[:contact_message])
    if @message.valid?
      NotificationMailer.new_message(@message).deliver
      #redirect_to(root_path, :alert => "Message was successfully sent.")
      @confirm = 1
      render :contact
    else
      #flash.now.alert = "Please fill all fields."
      logger.debug " found errors: #{@message.errors.messages.values.join(', ')} "
      @error="#{@message.errors.messages.values.join(', ')}"
      #render :action => "contact"
      #redirect_to :action=>:contact, :error=>@error
      render :contact
     #render :text => "FAILED VALIDATION"
    end
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
    redirect_to :controller=>loc[1], :action=>loc[0], :crop_avatar=>true
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
    redirect_to :controller=>loc[1], :action=>loc[0], :crop_cover=>true
  end
  
  def crop_cover
    path = File.join("#{DIR_PATH_COVERS}", "#{@user.cover}")
    img_file = Magick::Image.read(path).first
    sr = (img_file.columns/params[:sr].to_f)
    x=params[:x1].to_f * sr
    y=params[:y1].to_f * sr
    w=params[:w].to_f * sr
    h=params[:h].to_f * sr
    Image.crop(path,x,y,w,h)
    loc = request.referer.split('?')[0].split('/').reverse
    redirect_to :controller=>loc[1], :action=>loc[0]
  end
  
  def crop_avatar
    path = File.join("#{DIR_PATH_AVATARS}", "#{@user.avatar}")
    img_file = Magick::Image.read(path).first
    sr = (img_file.columns/params[:sr].to_f)
    x=params[:x1].to_f * sr
    y=params[:y1].to_f * sr
    w=params[:w].to_f * sr
    h=params[:h].to_f * sr
    Image.crop(path,x,y,w,h)
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
    # begin
      # @user=User.find(session[:user_id]) unless session[:user_id].nil?
    # rescue
      # session[:user_id] = nil
    # end
    @user = user_signed_in? ? current_user : nil   # ADJUSTED FOR DEVISE #
    logger.debug "loaded user: #{@user.full_name}" unless @user.nil?
    
    if !@user.nil? && @user.designer && params[:controller]=="site" && params[:action]=="index"
      redirect_to :controller=>:designer, :action=>:dashboard
    end
    
    
  end
    
end

class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end
  
  def create
    # Code here
    @user = User.new(params[:user])
    @user.shopper = 1

    if @user.save
      flash[:notice] = "You have signed up successfully. A confirmation was sent to your e-mail."
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def update
    super
  end
  
  def edit
    @user = User.find(params[:id])
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    @user.update_attributes(att.except(:id))
    if user.save
      logger.debug " user settings saved with id:#{user.id} "
    else
      logger.debug " found errors: #{user.errors.messages.values.join(', ')} "
      @error="#{user.errors.messages.values.join(', ')}"
    end
  end
  
########### PENDING DESIGNER REGISTRATION #####################################################  
  
  def register_designer
    @state=params[:state]
    @error=params[:error]
  end
  
  def register_designer_success
    logger.debug " creating a new pender "
    
    unless params[:agree_tos]=="on"
      @error="You need to agree to the Terms of Service"
      @state=params[:state]
      render "register_designer"
      return
    end
     
    user = User.new
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    #user = User.new(params[:user])
    user.update_attributes(attr.except(:id))
    user.pender=true
    user.password = Devise.friendly_token.first(8)
    logger.debug " pender to save: #{user.inspect} "
    user.skip_confirmation!
    if user.save
      logger.debug " pender saved with id:#{user.id} "
      UserMailer.pender_complete_request(user).deliver
    else
      logger.debug " found errors: #{user.errors.messages.values.join(', ')} "
      @error="#{user.errors.messages.values.join(', ')}"
      render "register_designer"
    end
    #redirect_to :action=>:list, :view=>view,  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  
end

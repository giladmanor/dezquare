class PenderController < SiteController
  
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
    user.update_attributes(attr.except(:id))
    user.pender=true
    user.password = "gsregsvergsegsr"
    logger.debug " pender to save: #{user.inspect} "
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

class PenderController < SiteController
  
  def designer
    
  end
  
  def designer_success
    logger.debug " creating a new pender "
    user = User.new  
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    user.update_attributes(attr.except(:id))
    user.pender=true
    logger.debug " pender to save: #{user.inspect} "
    #msg_t, msg = say("","")
    if user.save
      logger.debug " pender saved with id:#{user.id} "
      #msg_t, msg = say("info","#{user.name}'s Details Saved")
      UserMailer.pender_complete_request(user).deliver
    else
      logger.debug " found errors: #{user.errors.messages.values.join(', ')} "
      #msg_t, msg = say("error",user.errors.messages.values.join(', '))
      redirect_to :action=>:designer
    end
    #redirect_to :action=>:list, :view=>view,  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  
end

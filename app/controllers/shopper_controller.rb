class ShopperController < SiteController
  
  def register
    logger.debug " creating a new shopper "
    unless params[:agree_tos]=="on"
      @error="You need to agree to the Terms of Service"
      render "register_customer"
      return
    end
    
    user = User.new  
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    user.update_attributes(attr.except(:id))
    user.shopper=true
    logger.debug " shopper to save: #{user.inspect} "
    if user.save
      logger.debug " shopper saved with id:#{user.id} "
      UserMailer.shopper_complete_registration(user).deliver
      session[:user_id] = user.id
      redirect_to :controller=>:game,:action=>:index
    else
      logger.debug " found errors: #{user.errors.messages.values.join(', ')} "
      @error="#{user.errors.messages.values.join('</br>')}"
      render "register_customer"
    end
    
  end
    
  
end

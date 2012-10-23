class ShopperController < SiteController
  
  def register
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
      @error="#{user.errors.messages.values.join('</br>')}"
      render "register_customer"
    end
    
  end
    
  
end

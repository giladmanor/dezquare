class Registrator < StageImplementor
  
  
  def self.set(game,params,arguments)
    
    return unless game.user.nil?
    #return unless params[:agree_tos]=="on"
    if params[:trylogin].present?
      user = User.find_by_email(params[:user][:email])
      if user.present? && user.valid_password?(params[:user][:password]) && user.shopper
        game.user=user
        pass=1
      end
    else  
      user = User.new
      user.name=params[:name]
      user.l_name=params[:l_name]
      user.email=params[:email]
      user.password=params[:password]
      user.shopper=true
      if user.save
        game.user = user
        pass=1
      end
    end
    if pass
      #sign_in(user, :bypass => true)
      @user = user
        
      unless game.project.nil?
        game.project.shopper = user
        game.project.save
      end
      
    # else
          # logger.debug "------- #{user.errors.inspect}"
    end
    # logger.debug "------- #{user.id}"
  end
  
  def self.complete?(game,arguments)
    game.project.shopper = game.user
    game.project.save
    !game.user.nil?
  end
  
  def self.default_arguments
    nil
  end
  
  
end
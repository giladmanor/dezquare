class Registrator < StageImplementor
  
  
  def self.set(game,params,arguments)
    
    return unless game.user.nil?
    #return unless params[:agree_tos]=="on"
    user = User.new
    user.name=params[:name]
    user.l_name=params[:l_name]
    user.email=params[:email]
    user.password=params[:password]
    user.shopper=true
    if user.save
      game.user = user
      
      unless game.project.nil?
        game.project.shopper = user
        game.project.save
      end
      
    else
          logger.debug "------- #{user.errors.inspect}"
    end
    logger.debug "------- #{user.id}"
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
class Registrator < StageImplementor
  
  
  def self.set(game,params,arguments)
    
    return unless game.user.nil?
    
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
        
    end
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
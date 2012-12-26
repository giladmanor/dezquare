class PersonaImageRater < StageImplementor
  
  #args[:image_pool_size]
  #args[:required_image_likes]
  
  def self.set(game,params,arguments)
    logger.debug "params==== #{params.inspect}"
    logger.debug "arguments==== #{arguments.inspect}"
    
    unless params[:image_id].nil?
      image = Image.find(params[:image_id])
      gir = GameImageRate.new
      gir.image=image
      gir.game=game
      gir.value = params[:selected]=="like" ? 1 : -1
      gir.save  
    end
    
    
  end
  
  def self.complete?(game,arguments)
    (game.images.length>(Persona.all.size)) && (game.game_image_rates.select{|gir| gir.value>0}.length>1)
  end
  
  def self.default_arguments
    nil
  end
  
  
end
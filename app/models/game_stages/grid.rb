class Grid < StageImplementor
  
  #args[:image_pool_size]
  #args[:required_image_likes]
  
  def self.set(game,params,arguments)
    logger.debug "params==== #{params.inspect}"
    logger.debug "arguments==== #{arguments.inspect}"
    
    unless params[:images].nil?
      params[:images].each{|k,v|
        image = Image.find(k)
        gir = GameImageRate.new
        gir.image=image
        gir.game=game
        gir.value = v=="1" ? 1 : -1
        gir.save  
      }
    end
    
    
  end
  
  def self.complete?(game,arguments)
    (game.images.length>(Persona.all.size)) && (game.game_image_rates.select{|gir| gir.value>0}.length>1)
  end
  
  def self.default_arguments
    nil
  end
  
  
end
class ImageRater < StageImplementor
  
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
    logger.debug "ImageRater images rated: #{game.game_image_rates.length}"
    logger.debug "---------- positive rates: #{game.game_image_rates.select{|i| i.value>0}.length}"
    logger.debug "---------- requiered rates: #{arguments['required_image_likes']}"
    
    category = game.category
    images = category.image_grab(arguments["image_pool_size"].to_i).reject{|i| game.images.include?(i)}
    return true if images.length==0
    game.game_image_rates.select{|i| i.value>0}.length>=arguments["required_image_likes"].to_i
  end
  
  def self.default_arguments
    nil
  end
  
  
end
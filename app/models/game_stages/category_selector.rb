class CategorySelector < StageImplementor
  
  
  def self.set(game,params,arguments)
    logger.debug "==== #{params}"
    logger.debug "Category id==== #{params["category_id"]}"
    
    game.category=Category.find(params[:category_id])
    # game.max_price = params[:max_price].gsub("$","").to_f
    game.max_price = 9999999 # Temporarly set to default
  end
  
  def self.complete?(game,arguments)
    !game.category.nil? && game.max_price>0
  end
  
  def self.default_arguments
    nil
  end
  
  
end
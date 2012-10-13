class GameController < SiteController
  
  
  def index
    @game = Game.new
    @game.type=GameType.find_by_name(params[:id] || "test")
    @game.user=@user
    @game.category=Category.find(params[:category_id]) unless params[:category_id].nil?  
    @game.save
    
    session[:game_id]=@game.id
    logger.debug @game.view
    render @game.view
  end
  
  
  def next
    begin
      @game=Game.find(session[:game_id])
    rescue
      redirect_to :action=>:index
      return
    end
    
    @game.set(params) unless @game.is_complete 
    
    view = @game.view    
      
    
    unless @game.is_complete
      render view
    else
      redirect_to :controller=>:site,:action=>:index
    end
    
  end
  
end

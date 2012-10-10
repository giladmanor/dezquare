class GameController < SiteController
  
  
  def index
    @game = Game.new
    @game.game_type=GameType.find_by_name(params[:id] || "test")
    @game.user=@user
    @game.save
    
    render @game.stage_view
  end
  
  
  def stage
    
  end
  
end

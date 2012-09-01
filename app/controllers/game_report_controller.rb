class GameReportController < AdminController
  
  def list
    @game_type=GameType.find(params[:game_type_id])
  end
  
end

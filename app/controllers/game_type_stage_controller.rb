class GameTypeStageController < AdminController
  
  def list
    @parent = GameType.find(params[:game_type_id])
    @entities=@parent.game_type_stages
  end
  
  def stage
    @entity = params[:id].nil? ? GameTypeStage.new : GameTypeStage.find(params[:id])
    unless params[:game_type_id].nil?
      @parent = GameType.find(params[:game_type_id])
    else
      @parent = @entity.game_type
    end
     
  end
  
  
  def set
    @parent = GameType.find(params[:game_type_id]) unless params[:game_type_id].nil?
    @entity = params[:id].nil? ? GameTypeStage.new : GameTypeStage.find(params[:id])
    return if params[:do]=='new' || params[:do]=="edit"
    
    attr = params.delete_if{|k,v| !@entity.respond_to?(k.to_sym)}
    @entity.update_attributes(attr.except(:id))
    
    msg_t, msg = say("","")
    if @entity.save
      msg_t, msg = say("info","#{@entity.class.name.camelize} Saved")  
    else
      msg_t, msg = say("error",@entity.errors.messages.values.join(', '))
    end
    redirect_to :action=>:list, :game_type_id=>params[:game_type_id],  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  def delete
    gts = GameTypeStage.find(params[:id]) 
    game_type_id=gts.game_type.id
    gts.destroy
    redirect_to :action=>:list,  :server_sais=>"Deleted", :server_sais_type=>"info",:game_type_id=>game_type_id
  end
  
  
end

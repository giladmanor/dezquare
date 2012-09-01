class GameTypeController < AdminController

 def list
    cond = "1=1"
    unless params[:quick_search].nil?
      cond = ["name like ?","%#{params[:quick_search]}%"]
    end
    @entities=GameType.find(:all,:conditions=>cond);
  end
  
  def set
    return if params[:id]==:new
    
    entity = params[:id].nil? ? GameType.new : GameType.find(params[:id]) 
    attr = params.delete_if{|k,v| !entity.respond_to?(k.to_sym)}
    entity.update_attributes(attr.except(:id))
    
    msg_t, msg = say("","")
    if entity.save
      msg_t, msg = say("info","#{entity.class.name.camelize} Saved")  
    else
      msg_t, msg = say("error",entity.errors.messages.values.join(', '))
    end
    redirect_to :action=>:list, :id=>params[:parent_id],  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  def delete
    GameType.find(params[:id]).destroy
    redirect_to :action=>:list,  :server_sais=>"Deleted", :server_sais_type=>"info"
  end

end

class CategoryController < AdminController
  
  
  def list
    cond = "parent_id is null"
    unless params[:id].nil?
      cond = ["parent_id = ?",params[:id]]
    end
    unless params[:quick_search].nil?
      cond = ["name like ?","%#{params[:quick_search]}%"]
    end
    
    @categories=Category.find(:all,:conditions=>cond);
    @current = Category.find(params[:id]) unless  params[:id].nil?
  end
  
  def set
    cat = params[:id].nil? ? Category.new : Category.find(params[:id]) 
    cat.name = params[:name]
    cat.icon = params[:icon]
    cat.code = params[:code]
    
    cat.parent_id = params[:parent_id] unless params[:parent_id].nil?
    msg_t = "info"
    msg=""
    if cat.save
      msg="Category Saved"  
    else
      msg_t = "error"
      msg = cat.errors.messages.values.join(', ')
    end
    redirect_to :action=>:list, :id=>params[:parent_id],  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  def delete
    Category.find(params[:id]).destroy
    redirect_to :action=>:list,  :server_sais=>"Deleted", :server_sais_type=>"info"
  end
  
  
  
end

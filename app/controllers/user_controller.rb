class UserController < AdminController
  
  
   
  def list
    view = params[:view] 
    filter = "%#{params[:quick_search]}%"
    
    #type_filtering
    
    @users= case view.singularize
      when "shopper" then 
        User.where(:shopper=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
      when "designer" then 
        User.where(:designer=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
      when "pending" then 
        User.where(:pender=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
    end
    
    
    #@users = .take(50)
    
    render view
  end
  
  def create
    @user = User.new
    @game_data = {}
    @tags = []
    render params[:view] 
  end
  
  def shopper
    @user= params[:id].nil? ? User.new : User.find(params[:id])
    gp=@user.games.size
    gf=@user.games.where(:is_complete=>true).size
    cts=@user.games.where(:is_complete=>true).map{|g| g.game_image_rates.created_at}.sort{|x,y| y<=>x}
    act = (cts[0] - cts[cts.length])/gf unless cts.empty?
    pi=@user.games.map{|g| g.images}.flatten.length
    likes=@user.game_image_rates.map{|g| g.images}.flatten.length
    passes=@user.game_image_rates.map{|g| g.images}.flatten.length
    lg = cts=@user.games.where(:is_complete=>true).select{|g| g.game_image_rates[0].created_at-g.game_image_rates[g.game_image_rates.length].created_at > 10}.sort{|x,y| y<=>x}
    @game_data = {
      :games_playes=> gp,
      :games_finished=>gf,
      :perc_completed=> (gp==0) ? "N/A" : (gf/(gp+1)),
      :avg_complete_time=>act || "N/A" ,
      :avg_images_displayed=>(gp==0) ? "N/A" : (pi/(gp+1)),
      :count_likes=>likes,
      :count_passes=>passes,
      :long_games=>lg
      
    }
    all_tags = @user.games.map{|g| g.images.map{|i| i.tags}}.flatten
    @tags = all_tags.uniq.map{|t| {:name=>t.name, :gravity=>all_tags.count(t)}}
    
  end
  
  def designer
    @user= params[:id].nil? ? User.new : User.find(params[:id])
  end
  
  def pending
    @user= params[:id].nil? ? User.new : User.find(params[:id])
  end
  
  def set
    view = params[:view] 
    user = params[:id].nil? ? User.new : User.find(params[:id]) 
    generate_password=params[:generate_password]
    attr = params.delete_if{|k,v| !user.respond_to?(k.to_sym)}
    user.update_attributes(attr.except(:id))
    
    unless generate_password.nil?
      user.create_password(6) 
      user.pender=false
      user.designer=true  
    end
    
    
    msg_t, msg = say("","")
    if user.save
      msg_t, msg = say("info","#{user.name}'s Details Saved")
      UserMailer.designer_welcome(user).deliver unless generate_password.nil?
    else
      msg_t, msg = say("error",user.errors.messages.values.join(', '))
    end
    redirect_to :action=>:list, :view=>view,  :server_sais=>msg, :server_sais_type=>msg_t 
  end
  
  def set_user_languages
    view = params[:view] 
    lang_ids=params[:lang_ids]
    user = User.find(params[:id])
    user.language_ids=lang_ids
    
    msg_t, msg = say("","")
    if user.save
      msg_t, msg = say("info","#{user.name} Details Saved")
    else
      msg_t, msg = say("error",user.errors.messages.values.join(', '))
    end
    
    redirect_to :action=>view.singularize, :id=>user.id,  :server_sais=>msg, :server_sais_type=>msg_t
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action=>:list, :view=>params[:view],  :server_sais=>"Deleted", :server_sais_type=>"info"
  end
  
  def send_mail
    user = User.find(params[:id])
    UserMailer.send(params[:message],user).deliver
    render :text=>"Sent!"
  end
  
end

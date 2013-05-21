 class UserController < AdminController
  
  
   
  def list
    view = params[:view] 
    filter = "%#{params[:quick_search]}%"
    
    #type_filtering
      if view == "images"
        @images = Image.all #.find(:all, :conditions=>["name like ?", filter])
        
      end    
      
      @users= case view.singularize
        when "shopper" then 
          User.where(:shopper=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
        when "designer" then 
          User.where(:designer=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
        when "pending" then 
          User.where(:pender=>true).find(:all, :conditions=>["name like ? or l_name like ? or email like ?", filter, filter, filter])
        when "image" then
          nil
      end
    
      
    
    
    #@users = .take(50)
    
    render view
  end
  
  def create
    @user = User.new
    @game_data = {}
    @tags = []
    #@user.set_identifier
    render params[:view] 
  end
  
  def shopper
    @user= params[:id].nil? ? User.new : User.find(params[:id])
    gp=@user.games.size
    gf=@user.games.where(:is_complete=>true).size
    cts=@user.games.where(:is_complete=>true).map{|g| g.game_image_rates.map{|ir| ir.created_at}}.flatten.sort{|x,y| y<=>x}
    
    act = (cts[0] - cts[cts.length-1])/gf unless cts.empty?
    pi=@user.games.map{|g| g.images}.flatten.length
    likes=@user.game_image_rates.select{|i| i.value>0}.length
    passes=@user.game_image_rates.select{|i| i.value<0}.length
    lg = @user.games.where(:is_complete=>true).select{|g| g.game_image_rates.length > 20}.length
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
    #email_changed=0
     
    
    
    logger.debug "USER::::: #{user.email.inspect}" 
    if user.email.blank?
        logger.debug "######### BLANK !!! ##########"
        user.skip_confirmation!
        user.confirm!  
    elsif params[:email]!=user.email 
        # user.email = params[:email]
        user.skip_reconfirmation!
        logger.debug "######################## EMAIL CHANGED! #####################################" 
        logger.debug "USER::::: #{User.find(params[:id]).inspect}" 
    end
    
    user.assign_attributes(attr.except(:id, :url_identifier, :legacy_password_hash, :encrypted_password))
    
    
    if params[:legacy_password_hash].present? && params[:legacy_password_hash]!=user.legacy_password_hash
      user.xpassword= params[:legacy_password_hash]
    else
      if params[:encrypted_password].present?  && params[:encrypted_password]!=user.encrypted_password
        user.password=params[:encrypted_password] 
      end
    end
    
    if user.url_identifier.nil?
      user.set_identifier
    end
    
    unless generate_password.nil? # NEED TO ADAPT TO DEVISE (If user is Pender)
    #  user.create_password(6) 
      user.pender=false
      user.designer=true 
    #  user.email_confirm=true
 #     user.set_identifier
    else
      user.available=true
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
  
  def image
    @image = params[:id].nil? ? Image.new : Image.where("id = ?",params[:id]).first
    @user = @image.user
    @categories = Category.all
    @tags = Tag.all
    # @image = params[:id].present? ? @user.images.find(params[:id]) : Image.new 
    @crop = params[:crop]
  end
  
  def set_image
    view = params[:view] 
    @image = params[:id].nil? ? Image.new : Image.where("id = ?", params[:id]).first 
    @user = @image.user
 
    unless params[:upload].nil?
      #upload image
      begin
        @image = @user.set_image(params[:upload],DIR_PATH_REPOSITORY,@image.id)
        flash[:notice] = "File has been uploaded successfully"
        #redirect_to :action => "profile"
        logger.debug "file upload success"
        @crop = true
      rescue Exception => e
        flash[:error] = "Error with upload! Please retry."
        logger.debug "file upload failed"
        logger.debug "Error: #{e.inspect}"
      end  
    end
    
    #set details
    @image.name=params[:name]
    @image.description=params[:description]
    @image.category= Category.find_by_name(params[:category])
    @image.tag_ids=params[:tags]
    @image.dominant_colors= @image.get_dominant_colors
    @image.color_histogram= @image.get_color_histogram
    @image.user=@user
    #@image.save
    
    @user.set_designer_colors
    
    logger.debug "Image id: #{@image.id}"
    
    @categories = Category.all
    @tags = Tag.all
     msg_t, msg = say("","")
     if @image.save
       msg_t, msg = say("info","#{@image.id}'s Details Saved")
     else
       msg_t, msg = say("error",@image.errors.messages.values.join(', '))
     end
     redirect_to :action=>:list, :view=>view,  :server_sais=>msg, :server_sais_type=>msg_t      
 
  end
  # def sign_out
    # Devise::destroy_user_session
  # end
end

class DesignerController < SiteController
  
  before_filter :load_user, :except=>[:login, :register, :reset_password]
  skip_before_filter :shopper_zone, :only => [:dashboard, :settings]
  
  DIR_PATH_REPOSITORY = "#{Rails.root}/public/repository/"
  
  def dashboard
    logger.debug @user.inspect
    @categories = Category.all
    @author=@user
    @editable=true
    render "dashboard"
  end
  
  def invite_for_game
    #TODO
    redirect_to :action=>:dashboard, :show_invite_success=>true
  end
  ###############################################################################
  
  def profile
    @author = params[:id].present? ? User.find(params[:id]) : @user 
    
    @editable= (@author==@user)
  end
  
  def enlarged_view
    @image = Image.find(params[:id])
    @author = @image.user
    
    @editable= (@author==@user)
  end
  
  
  
  #########################################################################################################
  
  def set_details
    
    @user.name=params[:name]
    @user.l_name=params[:l_name]
    @user.location=params[:location]
    @user.about=params[:about]
    @user.public_profile=params[:public_profile]
    @user.dez_profile=params[:dez_profile]
    @user.suspend=params[:suspend]
    @user.languages=params[:language]
    
    @user.designer_categories.clear
    Category.all.each{ |c|
      ucp = DesignerCategory.new
      ucp.min_price=params["price_#{c.id}"].gsub("$","").to_f
      ucp.category_id=c.id
      @user.designer_categories << ucp
    }
    
    if params[:old_password].present? && @user.password==params[:old_password] && params[:new_password].present? && params[:new_password]==params[:repeat_password]
      @user.password=params[:new_password]
    end
        
    m=params[:month]
    y=params[:year]
    d=params[:day] || 1
    
    begin
      logger.debug Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
      @user.dob=Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
    rescue
      logger.debug "invalid date format"
    end
    
    
    @user.save
    redirect_to  :action => "profile"
  end
  
  
  
  def reset_password
    #TODO check if the user is a designer and send reset password mail
    
    redirect_to :controller=>:site, :action=> :index, :info=>"Please check your mail"
    
  end
  
  
  
  def settings
    @categories = Category.all
  end
  
  def set_availability
    if params[:stat]=="Available"
      @user.available = true
    else
      @user.available = false
    end
    @user.save
    redirect_to :action=>:profile
  end
  
  ###########################################################################################################
  
  def edit_photo
    @categories = Category.all
    @tags = Tag.all
    @image = params[:id].present? ? @user.images.find(params[:id]) : Image.new 
  end
  
  
  def set_photo
    @image = (params[:id].nil? || params[:id]=="") ? Image.new : @user.images.find(params[:id]) 
    unless params[:upload].nil?
      #upload image
      begin
        @image = @user.set_image(params[:upload],DIR_PATH_REPOSITORY,@image.id)
        flash[:notice] = "File has been uploaded successfully"
        #redirect_to :action => "profile"
        logger.debug "file upload success"
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
    @image.user=@user
    @image.save
    
    
    logger.debug "Image id: #{@image.id}"
    
    @categories = Category.all
    @tags = Tag.all
    
    if !@image.populated? || params[:save_and]=="continue"
      render "edit_photo"
      return
    end
    
    if params[:save_and]=="add"
      redirect_to  :action => "edit_photo"
    else
      redirect_to  :action => "profile"
    end
  end
  
  
  
  def upload_image
    begin
      id = (params[:id].nil? || params[:id]=="") ? nil : params[:id] 
      image = @user.set_image(params[:upload],DIR_PATH_REPOSITORY,id)
      flash[:notice] = "File has been uploaded successfully"
      #redirect_to :action => "profile"
      logger.debug "file upload success"
    rescue Exception => e
      flash[:error] = "Error with upload! Please retry."
      logger.debug "file upload failed"
      logger.debug "Error: #{e.inspect}"
    end
    redirect_to  :action => "edit_photo", :id=>image.id
  end
  
  def set_image_info
    image =(params[:id].nil? || params[:id]=="") ? Image.new : @user.images.find(params[:id]) 
    
    image.name=params[:name]
    image.description=params[:description]
    image.category= Category.find_by_name(params[:category])
    image.tag_ids=params[:tags]
    image.user=@user
    image.save
    
    if image.file_path.nil?
      redirect_to  :action => "edit_photo", :id=>image.id
      return
    elsif params[:save_and]=="add"
      redirect_to  :action => "edit_photo"
    else
      redirect_to  :action => "profile"
    end
  end
  
  def delete_image
    image = @user.images.find(params[:id])
    image.destroy unless image.nil?
    redirect_to :action=>"profile"
  end
  
  ###########################################################################################################
  
  
  
  
  
end

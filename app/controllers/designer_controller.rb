class DesignerController < SiteController
  
  before_filter :load_user, :except=>[:login, :register, :reset_password]
  
  DIR_PATH_AVATARS = "#{Rails.root}/public/user_avatars/"
  DIR_PATH_COVERS = "#{Rails.root}/public/user_covers/"
  DIR_PATH_REPOSITORY = "#{Rails.root}/public/repository/"
  
  def dashboard
    logger.debug @user.inspect
    @categories = Category.all.select{|c| c.parent_id!=nil}
    @author=@user
    @editable=true
    if @user.projects_in.empty? 
      render "dashboard_empty"
      return
    end
    
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
    Category.all.select{|c| c.parent_id!=nil}.each{ |c|
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
    
    logger.debug Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
    @user.dob=Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
    
    @user.save
    redirect_to  :action => "settings"
  end
  
  def load_user
    @user=User.find(session[:user_id])
  end
  
  def reset_password
    #TODO check if the user is a designer and send reset password mail
    
    redirect_to :controller=>:site, :action=> :index, :info=>"Please check your mail"
    
  end
  
  
  
  def settings
    @categories = Category.all.select{|c| c.parent_id!=nil}
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
    @categories = Category.all.select{|c| c.parent_id!=nil}
    @tags = Tag.all
    @image = params[:id].present? ? @user.images.find(params[:id]) : Image.new 
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
    image = @user.images.find(params[:id])
    if image.nil?
      redirect_to  :action => "edit_photo", :error=>"Please start by uploading an image"
      return
    end
    image.name=params[:name]
    image.description=params[:description]
    image.category= Category.find_by_name(params[:category])
    image.tag_ids=params[:tags]
    image.save
    
    if params[:save_and]=="add"
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
  
  def upload_avatar
    begin
      @user.set_avatar(params[:upload],DIR_PATH_AVATARS)
      flash[:notice] = "File has been uploaded successfully"
      #redirect_to :action => "profile"
      logger.debug "file upload success"
    rescue Exception => e
      flash[:error] = "Error with upload! Please retry."
      logger.debug "file upload failed"
      logger.debug "Error: #{e.inspect}"
    end
    redirect_to  :action => "profile"
  end
  
  def upload_cover
    begin
      @user.set_cover(params[:upload],DIR_PATH_COVERS)
      flash[:notice] = "File has been uploaded successfully"
      #redirect_to :action => "profile"
      logger.debug "file upload success"
    rescue Exception => e
      flash[:error] = "Error with upload! Please retry."
      logger.debug "file upload failed"
      logger.debug "Error: #{e.inspect}"
    end
    redirect_to  :action => "profile"
  end
  
  
  
end

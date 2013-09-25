class AdminController < ApplicationController
  before_filter :request_filter
  before_filter :server_sais_filter
  skip_before_filter :request_filter, :only => [:login, :index]
  
  def login
    
    if (params[:user]=="limor_jishai" && params[:password]=="ZA150535")
      session[:login]=:valid
      redirect_to :action=>:dashboard
      return
    end
    session[:login]=nil
    redirect_to :action=>:index, :server_sais=>'Bad Login attempt', :server_sais_type=>'error'
  end
  
  def logout
    session[:login]=nil
    redirect_to :action=>:index, :server_sais=>'User loged out', :server_sais_type=>'info'
  end
  
  def dashboard
    
  end
  
  
  
  def index
    #redirect_to :action=>:login
    render :layout=>false
  end
  
  
  #############################################################################################################
  def say(type,message)
    return type,message
  end
  
  
  def server_sais_filter
    @server_sais = params[:server_sais]
    @server_sais_type = params[:server_sais_type]
    @page_name = params[:action].camelize 
    @section_name = params[:controller].camelize 
  end
  
  def designer_overview
    
  end
  
  def request_filter
    logger.debug "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n Request Filter #{params[:action]} From[#{request.remote_ip}]"
    
    if session[:login]!=:valid
      logger.warn "(!) Invalid session"
      redirect_to :action=> 'index', :server_sais=>'Please login before accessing Admin', :server_sais_type=>'warning' 
      return
    end
    game_types=GameType.find(:all)
    @login_name = "Uncle Ruckus"
    @menu_items = [
      {:name=>'Main',:children=>[
        {:name=>'Dashboard',:class=>"icn_folder",:action=>'/admin/dashboard'},
        {:name=>'Shopper Management',:class=>"icn_view_users",:action=>'/user/list?view=shoppers'},
        {:name=>'Designer Management',:class=>"icn_view_users",:action=>'/user/list?view=designers'},
        {:name=>'Unregistered Designers',:class=>"icn_view_users",:action=>'/user/list?view=pendings'},
        {:name=>'Trending Projects', :class=>"icn_view_users",:action=>"/admin/bulletin_list/"}  ]},
      {:name=>'Configurations',:children=>[
        {:name=>'Categories',:class=>"icn_categories",:action=>'/category/list'},
        {:name=>'Tags',:class=>"icn_tags",:action=>'/tag/list'},
        {:name=>'Languages',:class=>"icn_audio",:action=>'/languages/list'},
        {:name=>'LSD: Languages',:class=>"icn_audio",:action=>'/lsd/list?entity=language'},
        {:name=>'Game Types',:class=>"icn_video",:action=>'/game_type/list'},
        {:name=>'NEW PROJECT',:class=>"icn_categories",:action=>'/admin/new_project'}]},
      {:name=>'Designer Reports',:children=>[
        {:name=>'Designer Overview Report',:class=>'icn_categories',:action=>'/admin/designer_overview'}  ]},
      {:name=>'Image Reports',:children=>[
        {:name=>'Image Overview Report',:class=>'icn_categories',:action=>'/admin/image_overview'}, 
        {:name=>'Image Stats Report',:class=>'icn_categories',:action=>'/admin/image_stats'}       
      ]},
      {:name=>'Game Reports',:children=> 
          game_types.map{|gt| {:name=>"#{gt.name}",:class=>"icn_categories",:action=>"/game_report/list?game_type_id=#{gt.id}"}}
      }
        
      ]
  end
  
  def new_project
    
  end
  
  def set_project
    @shopper = User.find_by_email(params[:shopper_email])
    @game = Game.new
    @project = Project.new

    
    @game.game_type_id = 1
    @game.user_id = @shopper.id
    @game.is_complete = 1
    @game.category_id = Category.find_by_name(params[:category]).id
    @game.max_price = 9999999
    
    @project.title = params[:project_title]
    @project.shopper_id = @shopper.id
    @project.category_id = @game.category_id
    @project.status = "started"
    @project.info = params[:project_details]
    @project.file_types = "jpg, png, psd, gif"
    @project.save    
    
    @game.project_id = @project.id
    @game.save
    

    @designers = params[:designers].split(",")
    @designers.each do |demail|
      @game_designer = GameDesigner.new
      @game_designer.game_id = @game.id
      
      @game_designer.user_id = User.find_by_email(demail).id
      @game_designer.save
    end   
    
    @images = params[:liked_images].split(",")
    @images.each do |img|
      @gir = GameImageRate.new
      @gir.game_id = @game.id
      @gir.image_id = img
      @gir.value = "1"
      @gir.save
    end
    
    
    redirect_to "/admin/dashboard"  
  end
  
  def bulletin_list
    @jobs = BulletinJob.all
  end
  
  def new_bulletin_job
    
     @job = params[:id].nil? ? BulletinJob.new : BulletinJob.find(params[:id])
     #@job = BulletinJob.find(1)
     logger.debug "***************** #{@job.inspect} *********************"
     #@designers = User.find(BulletinDesigner.all.select{ |bd| bd.bulletin_job_id==@job.id  }.collect{|db| db.user_id})
     #@desginers = User.joins(:bulletin_desinger)
     @designers = Array.new
     BulletinDesigner.all.map{ |bd|
       if bd.bulletin_job_id == @job.id
          @designers << User.find(bd.user_id)
       end
     }
     logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{@designers.inspect}"
  end
  
  def set_bulletin
     job = params[:id].nil? ? BulletinJob.new : BulletinJob.find(params[:id])
     
     if params[:upload].present?
       job.set_logo(params[:upload],"#{Rails.root}/public/logos/")
     end
     
     attr = params.delete_if{|k,v| !job.respond_to?(k.to_sym)}
     job.assign_attributes(attr.except(:id, :url_identifier, :upload))    
     
     if job.url_identifier.blank?
       job.set_identifier      
     end
     logger.debug "###################### BULLETIN: #{job.inspect} #########################"
     if job.save
       logger.debug "@@@@@@@@@@@@@ SAVED @@@@@@@@@@@@@@@"
     else
       logger.debug "FFFFFFFFFFFFFFFFFFFFAAAAAAAAAAAAIIIIIIIIIILLLLLLLEEEEEEEDDDDDDD"
     end
     redirect_to :controller => :admin, :action=> :bulletin_list
  end
  
  def delete_job
    BulletinJob.find(params[:id]).destroy
    redirect_to :controller => :admin, :action=> :bulletin_list
  end
  
end

class DesignerController < SiteController
  
  before_filter :load_user, :except=>[:login, :register, :reset_password]
  
  def dashboard
    render "dashboard_empty"
  end
  
  def profile
    
  end
  
  def set_details
    @user.name=params[:name]
    @user.l_name=params[:l_name]
    @user.location=params[:location]
    
    m=params[:month]
    y=params[:year]
    d=params[:day] || 1
    
    logger.debug Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
    @user.dob=Date.strptime("{ #{y}, #{m}, #{d} }", "{ %Y, %B, %d }")
    
    render :text=>@user.save
    
  end
  
  def load_user
    @user=User.find(session[:user_id])
  end
  
  def reset_password
    #todo: check if the user is a designer and send reset password mail
    
    redirect_to :controller=>:site, :action=> :index, :info=>"Please check your mail"
    
  end
  
  
  
end

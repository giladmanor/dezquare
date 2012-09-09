class DesignerController < SiteController
  
  before_filter :load_user, :except=>[:loggedin]
  
  def loggedin
    @user = User.find_by_email(params[:email])
    logger.debug "#{@user.inspect}"
    if !@user.nil? && @user.password==params[:password]
      session[:user_id]=@user.id
      return
    end
    loc = request.referer.split('?')[0].split('/').reverse
    redirect_to :controller=>loc[1], :action=>loc[0], :error=>"Wrong email or password"
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
  
end

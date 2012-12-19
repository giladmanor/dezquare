class GameController < SiteController
  before_filter :load_user
  
  def index
    @game = Game.new
    
    
    if params[:id].present?
      @game.type= GameType.find_by_name(params[:id])
    else 
      @game.type= GameType.all.first
    end
     
    @game.user=@user
    @game.category=Category.find(params[:category_id]) unless params[:category_id].nil?  
    @game.save
    
    session[:game_id]=@game.id
    logger.debug @game.view
    render @game.view
  end
  
  
  def next
    begin
      @game=Game.find(session[:game_id])
    rescue
      redirect_to :action=>:index
      return
    end
    
    @game.user = @user unless @user.nil?
    
    @game.set(params) unless @game.is_complete 
    view = @game.view    
    
    unless @game.is_complete
      render view
    else
      unless @game.user.nil?
        logger.debug "logging in user #{@game.user.full_name}"
        session[:user_id] = @game.user.id
      else
        logger.debug "     !!!     User is empty      !!!"
      end
      redirect_to :controller=>:site,:action=>:dashboard
    end
    
  end
  
  # Odd services
  
  def category_price_range
    #category = Category.find(params[:id])
    prices = DesignerCategory.find(:all, :conditions=>["category_id=?", params[:id]]).map{|dc| dc.min_price}.sort
    logger.debug prices.inspect
    res={
      :min_price=>prices[10] || 10,
      :max_price=>prices.last,
      :max_designers=>prices.length
      
    }
    render :json=>res
  end
  
  
  
  
end

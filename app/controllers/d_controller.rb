class DController < ApplicationController
  def index
    logger.debug params[:id]
    @author = User.find_by_direct_link(params[:id]) 
    
    unless @author.nil?
      render :file=>"designer/profile", :layout=>"designer"
    else
      redirect_to :action=>:omg
    end
    #redirect_to "/designer/profile/#{user.id}/#{params[:id]}"
  end
  
  def omg
    
  end
  
end

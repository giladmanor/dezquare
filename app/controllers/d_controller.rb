class DController < ApplicationController
  def index
    logger.debug params[:id]
    if params[:id].blank?
      redirect_to :action=>:ohno and return
    end
    @author = User.find_by_direct_link(params[:id]) 
    
    unless @author.nil?
      # render :file=>"designer/profile", :layout=>"designer"
     # render :controller=>:designer, :action=>:profile, :id=>"#{@author.url_identifier}"
     render :file=> "designer/dashboard", :id=>@author.url_identifier, :layout=>"designer"
    else
      redirect_to :action=>:ohno
    end
    #redirect_to "/designer/profile/#{user.id}/#{params[:id]}"
  end
  
  def ohno
    # render :file =>"d/#{["a","b"].shuffle.first}"
    render "d/a"
  end
  
end

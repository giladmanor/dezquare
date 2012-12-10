class DController < ApplicationController
  def index
    logger.debug params[:id]
    user= User.find_by_direct_link(params[:id]) 
    redirect_to "/designer/profile/#{user.id}/#{params[:id]}"
  end
end

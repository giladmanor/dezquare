class GkjhgkyfervController < ApplicationController
  def oauth
    o = request.env["omniauth.auth"]
    uid = o[:uid]
    provider = params["provider"]    
    logger.debug o["info"]
    
    
    render :file=> "/templates/#{@site.template_id}/#{@page.view}.html.erb", :layout=>"templates/#{@site.template_id}.html.erb"
  end
  
end

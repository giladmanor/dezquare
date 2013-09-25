class TrendingController < SiteController
  before_filter :authenticate_user!
  def index
    if current_user.designer?
      @jobs = BulletinJob.all
    else
      redirect_to :controller=>:home, :action=>:index
    end
    
  end


  def show
    if params[:id].present? && current_user.designer?
      @job = BulletinJob.find_by_url_identifier(params[:id])
    else 
      redirect_to :action=>:index
    end
  end
  
  def interested
    if params[:id].present? && current_user.designer?  
      bltn = BulletinJob.find_by_url_identifier(params[:id])
      bd = BulletinDesigner.new
      bd.user_id = current_user.id
      bd.bulletin_job_id = bltn.id
      if BulletinDesigner.where("user_id = ? AND bulletin_job_id = ?",bd.user_id,bd.bulletin_job_id).empty?
        bd.save
      # else
        # render :text=>"ALREADY SENT!" 
      end
    else 
      redirect_to "/designer/dashboard/"
      
    end
    
  end
  
end
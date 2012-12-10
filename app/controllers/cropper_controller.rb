class CropperController < ApplicationController
  DIR_PATH_REPOSITORY = "#{Rails.root}/public/repository/"
  
  
  def cropper
    @image = params[:id].nil? ? nil : Image.find(params[:id])
  end
  
  
  def crop_image
    logger.debug "-------------------------------------------------------------------------------------"
    image = Image.find(params[:id])
    
    image.crop_thumbnail(image,DIR_PATH_REPOSITORY,params[:x1],params[:y1],params[:w],params[:h],params[:sr] )
    
    
    logger.debug "-------------------------------------------------------------------------------------"
    redirect_to  :action => "cropper"
  end
  
  
end

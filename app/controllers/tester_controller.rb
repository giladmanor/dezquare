class TesterController < ApplicationController
  
  def t
    render :text=>Category.find(params[:id]).image_grab(100, 0)
  end
  
  def c
    
    render :text=>Category.all.map{|c| "#{c.name} #{c.images.size} by #{c.images.map{|i| i.user}.uniq.length} designers"}.join("</br>")
    
    
    
  end
  
  def clear
    
    render :text =>Rails.cache.clear 
  end
  
  
end

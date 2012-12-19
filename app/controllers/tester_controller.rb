class TesterController < ApplicationController
  
  def t
    render :text=>Category.find(params[:id]).image_grab(100, 0)
  end
  
  def c
    
    render :text=>Category.all.map{|c| "#{c.name} #{c.images.size} by #{c.images.map{|i| i.user}.uniq.length} designers"}.join("</br>")
    
    
    
  end
  
  def itg
    res = Game.all.select{|g| g.images.size>0}.map{|g| g.images}.flatten.length/Game.all.select{|g| g.images.size>0}.size
    render :text =>res
  end
  
  def locations
    res = User.all.select{|d| d.designer && !d.location.nil? && d.location.length>0}.map{|d| d.location}.compact.sort
    u = res.uniq
    render :text=> u.map{|i| "#{i} (#{res.count(i)})"}.join("</br>")
  end
  
  
end

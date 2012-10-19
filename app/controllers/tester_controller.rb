class TesterController < ApplicationController
  
  def t
    
    render :text=>Category.find(params[:id]).image_grab(100, 0)
  end
  
  
end

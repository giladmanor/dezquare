class TexController < ApplicationController
  def t
      
      list_users = []
      
      User.where("designer =1").each{|user|
        logger.debug user.id
        nam_down = user.name.downcase
        last_down = user.l_name.downcase
        new_nam = "#{nam_down}_#{last_down}"
        while list_users.include?(new_nam) do
          new_nam = "#{new_nam}_1" 
        end
        user.direct_link = new_nam
        user.save
      }
        
      render :text => 'is good'
  
    #def name
    #User.where("designer =1").downcase
    #end
  
  end
end
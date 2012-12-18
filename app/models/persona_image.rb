class PersonaImage < ActiveRecord::Base
  belongs_to :persona
  belongs_to :user
  
  
  
end

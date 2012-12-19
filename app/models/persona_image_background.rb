class PersonaImageBackground < ActiveRecord::Base
  belongs_to :persona
  belongs_to :user
end

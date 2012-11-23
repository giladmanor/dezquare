class PersonaTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :persona
end

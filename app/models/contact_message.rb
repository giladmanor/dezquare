class ContactMessage
  
include ActiveModel::Validations
include ActiveModel::Conversion
extend ActiveModel::Naming

attr_accessor :name, :email, :subject, :body

validates :name, :email, :subject, :body, :presence => true
validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message=>"%{value} is an invalid email" }
#validates_length_of :body, :in => 5..800

def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
end

def persisted?
  false
end



end
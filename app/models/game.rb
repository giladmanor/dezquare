class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_image_rates
  has_many :images, :through=>:game_image_rates
  
end

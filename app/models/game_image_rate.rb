class GameImageRate < ActiveRecord::Base
  belongs_to :game
  belongs_to :image
end

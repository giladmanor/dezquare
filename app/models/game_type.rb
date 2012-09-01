class GameType < ActiveRecord::Base
  has_many :game_type_stages
end

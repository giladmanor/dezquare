class ImageCategory < ActiveRecord::Base
  belongs_to :image
  belongs_to :category
end

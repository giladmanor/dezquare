require 'RMagick'
require 'prizm'

class Game < ActiveRecord::Base
  belongs_to :user
  serialize :data, Hash
  serialize :dominant_colors, Array
  
  has_many :game_image_rates
  has_many :images, :through=>:game_image_rates
  
  has_many :projects_in, :class_name=>"Project" ,:foreign_key => "designer_id"
  
  belongs_to :type, :class_name=>"GameType",:foreign_key => "game_type_id"
  belongs_to :stage, :class_name=>"GameTypeStage",:foreign_key => "game_type_stage_id"
  
  belongs_to :category
  belongs_to :project
  
  has_many :game_designers
  has_many :designers, :through=>:game_designers, :class_name=>"User", :foreign_key=>"user_id", :source=>:user
  
  has_many :game_matches
  
  
  def set(params)
    self.stage.set(self,params)
    self.save
  end
  
  def view
    
    if self.stage.nil?
      self.stage = self.type.game_type_stages.first 
    else
      while !self.stage.nil? && self.stage.complete?(self)
        self.is_complete, self.stage = self.type.stage_after(stage)
      end
    end
    
    self.save
    
    if self.is_complete
      nil
    else
      stage.view
    end
  end
  
  
  def set_dominant_colors
    image_rates= self.game_image_rates.where("game_id = ? AND value = ?", self.id, "1") 
   # if image_rates.blank? 
   #   return 0
   # end
   # cols = []
   # image_rates.each do |img|
   #   logger.debug "IMAGE RATES::::: #{img.inspect}"
   #   
   #   img.image.dominant_colors.map {|c| cols<<c}
   #   logger.debug "COLORS::::: #{cols}"
   # end
   # new_image = Magick::Image.new(cols.length, 1)
   # cols.length.times do |pxl|      
   #   new_image.pixel_color(pxl,0, cols[pxl])
   # end
   # new_image = new_image.quantize(7)
   # new_image = new_image.unique_colors
   # histo = new_image.color_histogram()
   # #logger.debug "HISTOGRAM:::::: #{histo}"
   # dom_cols = []
   # histo.map {|p, q| dom_cols << to_hex(p)}
   # logger.debug "DOM COLORS:::::: #{dom_cols}"
   images = []
   image_rates.map { |ir| images << ir.image}
   dom_cols = Image.multicolors(images)  
    self.dominant_colors = dom_cols
    self.save
    #new_image.write('colortemp.gif')
    return 1
  end
  
end

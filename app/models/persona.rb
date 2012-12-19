class Persona < ActiveRecord::Base
  has_many :persona_tags
  has_many :tags, :through=>:persona_tags
  
  has_many :persona_images
  has_many :images, :through=>:persona_images
  
  has_many :persona_image_backgrounds
  
  
  def self.find_by_tags(tags)
    flat=tags.map{|t| t.personas}.flatten
    
    personas = Persona.all.map{|p| {:p=>p, :rate=>flat.count(p)}}.sort{|a,b| b[:rate]<=>a[:rate]}
    logger.debug "list of persona's: #{personas.inspect}"
    personas.first
  end
  
  def set_tag_ids(ids)
    self.tags.clear
    ids.each{|tid|
      self.tags<< Tag.find(tid)
      }
    self.save
  end
  
  # def images
    # Image.all.map{|i| {:i=>i,:dev=>(i.tags-self.tags).length}}.sort{|a,b| a[:dev]<=>b[:dev]}.map{|i| i[:i]}
  # end
  
end

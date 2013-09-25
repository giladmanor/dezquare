class BulletinJob < ActiveRecord::Base
  #has_many :designers, :through=>:interested_designers
  #attr_accessor :category, :company_name, :location, :date, :about_company, :about_project,
 #               :required_skills, :required_experience, :logo_path, :url_identifier
                
  def set_identifier
    identifier = '1'
    begin
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
      identifier  =  (0...20).map{ o[rand(o.length)] }.join
    end while BulletinJob.where("url_identifier = ?", identifier).present?
    self.url_identifier = identifier
  end
  
  def file_suffix(file_name)
    file_name.split(".").reverse.first
  end
  
  def set_logo(upload,dir)
    self.logo_path = "#{self.id}.#{file_suffix(upload.original_filename)}"

    # create the file path
    path = File.join("#{dir}", "#{self.logo_path}")
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.save
  end
  
end
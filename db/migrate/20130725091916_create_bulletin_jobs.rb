class CreateBulletinJobs < ActiveRecord::Migration
  def change
    create_table :bulletin_jobs do |t|
      t.string :category
      t.string :company_name
      t.string :location
      t.string :date
      t.text :about_company
      t.text :about_project
      t.text :required_skills
      t.text :required_experience
      t.text :logo_path
      t.string :url_identifier
      
 
      t.timestamps
    end
    
  end

end

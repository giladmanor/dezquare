class CreateBulletinDesigners < ActiveRecord::Migration
  
  def change
    create_table :bulletin_designers do |t|
      t.references :bulletin_job
      t.references :user

      t.timestamps
    end
    add_index :bulletin_designers, :bulletin_job_id
    add_index :bulletin_designers, :user_id
  end

end

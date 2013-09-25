class BulletinDesigner < ActiveRecord::Base
  belongs_to :bulletin_job
  belongs_to :user
end
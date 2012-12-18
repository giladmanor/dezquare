# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121213095238) do

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "icon"
    t.string   "code"
  end

  create_table "designer_categories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.decimal  "min_price",   :precision => 10, :scale => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "designer_categories", ["category_id"], :name => "index_designer_categories_on_category_id"
  add_index "designer_categories", ["user_id"], :name => "index_designer_categories_on_user_id"

  create_table "game_designers", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_designers", ["game_id"], :name => "index_game_designers_on_game_id"
  add_index "game_designers", ["user_id"], :name => "index_game_designers_on_user_id"

  create_table "game_image_rates", :force => true do |t|
    t.integer  "game_id"
    t.integer  "image_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_image_rates", ["game_id"], :name => "index_game_image_rates_on_game_id"
  add_index "game_image_rates", ["image_id"], :name => "index_game_image_rates_on_image_id"

  create_table "game_matches", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "rate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_matches", ["game_id"], :name => "index_game_matches_on_game_id"
  add_index "game_matches", ["user_id"], :name => "index_game_matches_on_user_id"

  create_table "game_type_stages", :force => true do |t|
    t.integer  "game_type_id"
    t.integer  "ord"
    t.string   "imp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "arguments"
    t.string   "progress_label"
  end

  add_index "game_type_stages", ["game_type_id"], :name => "index_game_type_stages_on_game_type_id"

  create_table "game_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "game_type_id"
    t.integer  "game_type_stage_id"
    t.integer  "user_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.boolean  "is_complete"
    t.integer  "category_id"
    t.integer  "project_id"
    t.decimal  "max_price",          :precision => 10, :scale => 0
  end

  add_index "games", ["game_type_id"], :name => "index_games_on_game_type_id"
  add_index "games", ["game_type_stage_id"], :name => "index_games_on_game_type_stage_id"
  add_index "games", ["user_id"], :name => "index_games_on_user_id"

  create_table "image_categories", :force => true do |t|
    t.integer  "image_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "image_categories", ["category_id"], :name => "index_image_categories_on_category_id"
  add_index "image_categories", ["image_id"], :name => "index_image_categories_on_image_id"

  create_table "image_comments", :force => true do |t|
    t.integer  "image_id"
    t.string   "type"
    t.string   "text"
    t.integer  "loc_x"
    t.integer  "loc_y"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "image_comments", ["image_id"], :name => "index_image_comments_on_image_id"

  create_table "image_tags", :force => true do |t|
    t.integer  "image_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "image_tags", ["image_id"], :name => "index_image_tags_on_image_id"
  add_index "image_tags", ["tag_id"], :name => "index_image_tags_on_tag_id"

  create_table "images", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "file_path"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.integer  "ord"
  end

  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "persona_images", :force => true do |t|
    t.integer  "persona_id"
    t.string   "description"
    t.string   "file_path"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "persona_images", ["persona_id"], :name => "index_persona_images_on_persona_id"

  create_table "persona_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "persona_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "persona_tags", ["persona_id"], :name => "index_persona_tags_on_persona_id"
  add_index "persona_tags", ["tag_id"], :name => "index_persona_tags_on_tag_id"

  create_table "personas", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "project_comments", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_comments", ["project_id"], :name => "index_project_comments_on_project_id"
  add_index "project_comments", ["user_id"], :name => "index_project_comments_on_user_id"

  create_table "project_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_tags", ["project_id"], :name => "index_project_tags_on_project_id"
  add_index "project_tags", ["tag_id"], :name => "index_project_tags_on_tag_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "shopper_id"
    t.integer  "designer_id"
    t.integer  "category_id"
    t.decimal  "cost",        :precision => 10, :scale => 0
    t.string   "status"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.text     "info"
    t.string   "file_types"
  end

  add_index "projects", ["category_id"], :name => "index_projects_on_category_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "adjective"
  end

  create_table "user_languages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_languages", ["language_id"], :name => "index_user_languages_on_language_id"
  add_index "user_languages", ["user_id"], :name => "index_user_languages_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "ext_id"
    t.string   "ext_id_imp"
    t.string   "name"
    t.string   "l_name"
    t.string   "email"
    t.string   "nick"
    t.string   "password"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.date     "dob"
    t.string   "location"
    t.string   "portfolio_link"
    t.boolean  "shopper",        :default => false
    t.boolean  "designer",       :default => false
    t.boolean  "pender",         :default => false
    t.boolean  "available",      :default => false
    t.text     "about"
    t.boolean  "public_profile", :default => false
    t.boolean  "dez_profile",    :default => false
    t.boolean  "suspend",        :default => false
    t.string   "avatar"
    t.string   "cover"
    t.string   "direct_link"
    t.string   "education"
    t.string   "skills"
    t.boolean  "email_confirm"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["ext_id"], :name => "index_users_on_ext_id"
  add_index "users", ["nick"], :name => "index_users_on_nick"

end

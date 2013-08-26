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

ActiveRecord::Schema.define(:version => 20130611092641) do

  create_table "menu_day_entities", :force => true do |t|
    t.integer "parent_id"
    t.integer "day_id"
    t.integer "entity_type",                :null => false
    t.integer "entity_id",                  :null => false
    t.integer "weight",      :default => 0, :null => false
  end

  create_table "menu_days", :force => true do |t|
    t.integer "menu_id"
    t.integer "num"
  end

  create_table "menu_dish_categories", :force => true do |t|
  end

  create_table "menu_dish_category_translations", :force => true do |t|
    t.integer  "menu_dish_category_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "menu_dish_category_translations", ["locale"], :name => "index_menu_dish_category_translations_on_locale"
  add_index "menu_dish_category_translations", ["menu_dish_category_id"], :name => "index_menu_dish_category_translations_on_menu_dish_category_id"

  create_table "menu_dish_products", :force => true do |t|
    t.integer "dish_id"
    t.integer "product_id"
    t.integer "weight"
  end

  create_table "menu_dish_translations", :force => true do |t|
    t.integer  "menu_dish_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "menu_dish_translations", ["locale"], :name => "index_menu_dish_translations_on_locale"
  add_index "menu_dish_translations", ["menu_dish_id"], :name => "index_menu_dish_translations_on_menu_dish_id"

  create_table "menu_dishes", :force => true do |t|
    t.integer "dish_category_id"
  end

  create_table "menu_meal_translations", :force => true do |t|
    t.integer  "menu_meal_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "menu_meal_translations", ["locale"], :name => "index_menu_meal_translations_on_locale"
  add_index "menu_meal_translations", ["menu_meal_id"], :name => "index_menu_meal_translations_on_menu_meal_id"

  create_table "menu_meals", :force => true do |t|
  end

  create_table "menu_menus", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",       :default => "",    :null => false
    t.integer  "users_qty",  :default => 1,     :null => false
    t.boolean  "is_public",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "menu_product_categories", :force => true do |t|
  end

  create_table "menu_product_category_translations", :force => true do |t|
    t.integer  "menu_product_category_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "menu_product_category_translations", ["locale"], :name => "index_menu_product_category_translations_on_locale"
  add_index "menu_product_category_translations", ["menu_product_category_id"], :name => "index_6680f3b847633177684d3ec6549dd62931982788"

  create_table "menu_product_translations", :force => true do |t|
    t.integer  "menu_product_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "menu_product_translations", ["locale"], :name => "index_menu_product_translations_on_locale"
  add_index "menu_product_translations", ["menu_product_id"], :name => "index_menu_product_translations_on_menu_product_id"

  create_table "menu_products", :force => true do |t|
    t.integer "product_category_id",                :null => false
    t.integer "calories",            :default => 0, :null => false
    t.integer "proteins",            :default => 0, :null => false
    t.integer "fats",                :default => 0, :null => false
    t.integer "carbohydrates",       :default => 0, :null => false
  end

  create_table "regions", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "description", :default => "", :null => false
    t.text     "track",       :default => "", :null => false
    t.string   "url",         :default => "", :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "region_id"
    t.integer  "user_id"
  end

  add_index "tracks", ["region_id"], :name => "index_tracks_on_region_id"
  add_index "tracks", ["user_id"], :name => "index_tracks_on_user_id"

  create_table "trip_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trip_comments", ["trip_id"], :name => "index_trip_comments_on_trip_id"

  create_table "trip_users", :force => true do |t|
    t.integer "trip_id"
    t.integer "user_id"
    t.boolean "approved", :default => false
  end

  add_index "trip_users", ["trip_id"], :name => "index_trip_users_on_trip_id"
  add_index "trip_users", ["user_id"], :name => "index_trip_users_on_user_id"

  create_table "trips", :force => true do |t|
    t.integer  "track_id"
    t.date     "start_date",                          :null => false
    t.date     "end_date",                            :null => false
    t.text     "trip_details",                        :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "user_id"
    t.string   "url"
    t.integer  "available_places",                    :null => false
    t.boolean  "has_guide",        :default => false, :null => false
  end

  add_index "trips", ["start_date"], :name => "index_trips_on_start_date"
  add_index "trips", ["user_id"], :name => "index_trips_on_user_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "about",            :default => "", :null => false
    t.text     "experience",       :default => "", :null => false
    t.text     "equipment",        :default => "", :null => false
    t.text     "contacts",         :default => "", :null => false
    t.text     "private_contacts", :default => "", :null => false
    t.text     "private_info",     :default => "", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "email_hash"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

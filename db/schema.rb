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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160221200132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "menu_day_entities", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "day_id"
    t.integer "entity_type", limit: 2,             null: false
    t.integer "entity_id",                         null: false
    t.integer "weight",                default: 0, null: false
    t.integer "sort_order",            default: 0, null: false
    t.string  "custom_name"
    t.string  "notes"
  end

  add_index "menu_day_entities", ["day_id"], name: "index_menu_day_entities_on_day_id", using: :btree

  create_table "menu_days", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "num"
    t.decimal "coverage", precision: 3, scale: 2, default: 0.0, null: false
    t.string  "notes"
  end

  add_index "menu_days", ["menu_id"], name: "index_menu_days_on_menu_id", using: :btree

  create_table "menu_dish_categories", force: :cascade do |t|
    t.hstore   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_dish_category_translations", force: :cascade do |t|
    t.integer  "menu_dish_category_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name"
  end

  add_index "menu_dish_category_translations", ["locale"], name: "index_menu_dish_category_translations_on_locale", using: :btree
  add_index "menu_dish_category_translations", ["menu_dish_category_id"], name: "index_menu_dish_category_translations_on_menu_dish_category_id", using: :btree

  create_table "menu_dish_products", force: :cascade do |t|
    t.integer "dish_id"
    t.integer "product_id"
    t.integer "weight"
    t.integer "sort_order", default: 0, null: false
  end

  create_table "menu_dish_translations", force: :cascade do |t|
    t.integer  "menu_dish_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.text     "description"
  end

  add_index "menu_dish_translations", ["locale"], name: "index_menu_dish_translations_on_locale", using: :btree
  add_index "menu_dish_translations", ["menu_dish_id"], name: "index_menu_dish_translations_on_menu_dish_id", using: :btree

  create_table "menu_dishes", force: :cascade do |t|
    t.integer  "dish_category_id"
    t.integer  "user_id"
    t.boolean  "is_public",          default: false, null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.hstore   "name"
    t.hstore   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_meal_translations", force: :cascade do |t|
    t.integer  "menu_meal_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
  end

  add_index "menu_meal_translations", ["locale"], name: "index_menu_meal_translations_on_locale", using: :btree
  add_index "menu_meal_translations", ["menu_meal_id"], name: "index_menu_meal_translations_on_menu_meal_id", using: :btree

  create_table "menu_meals", force: :cascade do |t|
    t.hstore   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_menus", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                                default: "",    null: false
    t.string   "read_key",                            default: "",    null: false
    t.string   "edit_key",                            default: "",    null: false
    t.integer  "users_count",                         default: 1,     null: false
    t.integer  "days_count",                          default: 0,     null: false
    t.decimal  "coverage",    precision: 5, scale: 2, default: 0.0,   null: false
    t.boolean  "is_public",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "menu_menus", ["is_public"], name: "index_menu_menus_on_is_public", using: :btree
  add_index "menu_menus", ["user_id"], name: "index_menu_menus_on_user_id", using: :btree

  create_table "menu_partition_porter_products", force: :cascade do |t|
    t.integer "partition_porter_id"
    t.integer "day_entity_id"
  end

  add_index "menu_partition_porter_products", ["partition_porter_id"], name: "index_menu_partition_porter_products_on_partition_porter_id", using: :btree

  create_table "menu_partition_porters", force: :cascade do |t|
    t.integer  "partition_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_partition_porters", ["partition_id"], name: "index_menu_partition_porters_on_partition_id", using: :btree

  create_table "menu_partitions", force: :cascade do |t|
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_partitions", ["menu_id"], name: "index_menu_partitions_on_menu_id", using: :btree

  create_table "menu_product_categories", force: :cascade do |t|
    t.hstore   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_product_category_translations", force: :cascade do |t|
    t.integer  "menu_product_category_id", null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name"
  end

  add_index "menu_product_category_translations", ["locale"], name: "index_menu_product_category_translations_on_locale", using: :btree
  add_index "menu_product_category_translations", ["menu_product_category_id"], name: "index_6680f3b847633177684d3ec6549dd62931982788", using: :btree

  create_table "menu_product_translations", force: :cascade do |t|
    t.integer  "menu_product_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.text     "description"
    t.text     "norm_info"
  end

  add_index "menu_product_translations", ["locale"], name: "index_menu_product_translations_on_locale", using: :btree
  add_index "menu_product_translations", ["menu_product_id"], name: "index_menu_product_translations_on_menu_product_id", using: :btree

  create_table "menu_products", force: :cascade do |t|
    t.integer  "product_category_id",                 null: false
    t.integer  "calories",            default: 0,     null: false
    t.integer  "proteins",            default: 0,     null: false
    t.integer  "fats",                default: 0,     null: false
    t.integer  "carbohydrates",       default: 0,     null: false
    t.integer  "norm",                default: 0,     null: false
    t.integer  "user_id"
    t.boolean  "is_public",           default: false, null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.hstore   "name"
    t.hstore   "description"
    t.hstore   "norm_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description"
    t.text     "track"
    t.string   "url",         default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.integer  "user_id"
  end

  add_index "tracks", ["region_id"], name: "index_tracks_on_region_id", using: :btree
  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id", using: :btree

  create_table "trip_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trip_comments", ["trip_id"], name: "index_trip_comments_on_trip_id", using: :btree

  create_table "trip_users", force: :cascade do |t|
    t.integer "trip_id"
    t.integer "user_id"
    t.boolean "approved", default: false
  end

  add_index "trip_users", ["trip_id"], name: "index_trip_users_on_trip_id", using: :btree
  add_index "trip_users", ["user_id"], name: "index_trip_users_on_user_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.integer  "track_id"
    t.date     "start_date",                       null: false
    t.date     "end_date",                         null: false
    t.text     "trip_details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "url"
    t.integer  "available_places",                 null: false
    t.boolean  "has_guide",        default: false, null: false
    t.integer  "menu_id"
    t.integer  "cached_duration"
  end

  add_index "trips", ["start_date"], name: "index_trips_on_start_date", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "about"
    t.text     "experience"
    t.text     "equipment"
    t.text     "contacts"
    t.text     "private_contacts"
    t.text     "private_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email_hash"
    t.string   "authentication_token"
    t.string   "role"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

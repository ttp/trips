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

ActiveRecord::Schema.define(version: 20141214184153) do

  create_table "menu_day_entities", force: :cascade do |t|
    t.integer "parent_id",   limit: 4
    t.integer "day_id",      limit: 4
    t.integer "entity_type", limit: 1,             null: false
    t.integer "entity_id",   limit: 4,             null: false
    t.integer "weight",      limit: 4, default: 0, null: false
    t.integer "sort_order",  limit: 4, default: 0, null: false
  end

  add_index "menu_day_entities", ["day_id"], name: "index_menu_day_entities_on_day_id", using: :btree

  create_table "menu_days", force: :cascade do |t|
    t.integer "menu_id",  limit: 4
    t.integer "num",      limit: 4
    t.decimal "coverage",           precision: 3, scale: 2, default: 0.0, null: false
  end

  add_index "menu_days", ["menu_id"], name: "index_menu_days_on_menu_id", using: :btree

  create_table "menu_dish_categories", force: :cascade do |t|
  end

  create_table "menu_dish_category_translations", force: :cascade do |t|
    t.integer  "menu_dish_category_id", limit: 4,   null: false
    t.string   "locale",                limit: 255, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "name",                  limit: 255
  end

  add_index "menu_dish_category_translations", ["locale"], name: "index_menu_dish_category_translations_on_locale", using: :btree
  add_index "menu_dish_category_translations", ["menu_dish_category_id"], name: "index_menu_dish_category_translations_on_menu_dish_category_id", using: :btree

  create_table "menu_dish_products", force: :cascade do |t|
    t.integer "dish_id",    limit: 4
    t.integer "product_id", limit: 4
    t.integer "weight",     limit: 4
    t.integer "sort_order", limit: 4, default: 0, null: false
  end

  create_table "menu_dish_translations", force: :cascade do |t|
    t.integer  "menu_dish_id", limit: 4,     null: false
    t.string   "locale",       limit: 255,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
  end

  add_index "menu_dish_translations", ["locale"], name: "index_menu_dish_translations_on_locale", using: :btree
  add_index "menu_dish_translations", ["menu_dish_id"], name: "index_menu_dish_translations_on_menu_dish_id", using: :btree

  create_table "menu_dishes", force: :cascade do |t|
    t.integer  "dish_category_id",   limit: 4
    t.string   "icon",               limit: 255, default: "",    null: false
    t.integer  "user_id",            limit: 4
    t.boolean  "is_public",          limit: 1,   default: false, null: false
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "menu_meal_translations", force: :cascade do |t|
    t.integer  "menu_meal_id", limit: 4,   null: false
    t.string   "locale",       limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",         limit: 255
  end

  add_index "menu_meal_translations", ["locale"], name: "index_menu_meal_translations_on_locale", using: :btree
  add_index "menu_meal_translations", ["menu_meal_id"], name: "index_menu_meal_translations_on_menu_meal_id", using: :btree

  create_table "menu_meals", force: :cascade do |t|
  end

  create_table "menu_menus", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255,                         default: "",    null: false
    t.string   "read_key",    limit: 255,                         default: "",    null: false
    t.string   "edit_key",    limit: 255,                         default: "",    null: false
    t.integer  "users_count", limit: 4,                           default: 1,     null: false
    t.integer  "days_count",  limit: 4,                           default: 0,     null: false
    t.decimal  "coverage",                precision: 5, scale: 2, default: 0.0,   null: false
    t.boolean  "is_public",   limit: 1,                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_menus", ["is_public"], name: "index_menu_menus_on_is_public", using: :btree
  add_index "menu_menus", ["user_id"], name: "index_menu_menus_on_user_id", using: :btree

  create_table "menu_partition_porter_products", force: :cascade do |t|
    t.integer "partition_porter_id", limit: 4
    t.integer "day_entity_id",       limit: 4
  end

  add_index "menu_partition_porter_products", ["partition_porter_id"], name: "index_menu_partition_porter_products_on_partition_porter_id", using: :btree

  create_table "menu_partition_porters", force: :cascade do |t|
    t.integer  "partition_id", limit: 4
    t.integer  "user_id",      limit: 4
    t.string   "name",         limit: 255
    t.integer  "position",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_partition_porters", ["partition_id"], name: "index_menu_partition_porters_on_partition_id", using: :btree

  create_table "menu_partitions", force: :cascade do |t|
    t.integer  "menu_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_partitions", ["menu_id"], name: "index_menu_partitions_on_menu_id", using: :btree

  create_table "menu_product_categories", force: :cascade do |t|
  end

  create_table "menu_product_category_translations", force: :cascade do |t|
    t.integer  "menu_product_category_id", limit: 4,   null: false
    t.string   "locale",                   limit: 255, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "name",                     limit: 255
  end

  add_index "menu_product_category_translations", ["locale"], name: "index_menu_product_category_translations_on_locale", using: :btree
  add_index "menu_product_category_translations", ["menu_product_category_id"], name: "index_6680f3b847633177684d3ec6549dd62931982788", using: :btree

  create_table "menu_product_translations", force: :cascade do |t|
    t.integer  "menu_product_id", limit: 4,     null: false
    t.string   "locale",          limit: 255,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.text     "norm_info",       limit: 65535
  end

  add_index "menu_product_translations", ["locale"], name: "index_menu_product_translations_on_locale", using: :btree
  add_index "menu_product_translations", ["menu_product_id"], name: "index_menu_product_translations_on_menu_product_id", using: :btree

  create_table "menu_products", force: :cascade do |t|
    t.integer  "product_category_id", limit: 4,                   null: false
    t.integer  "calories",            limit: 4,   default: 0,     null: false
    t.integer  "proteins",            limit: 4,   default: 0,     null: false
    t.integer  "fats",                limit: 4,   default: 0,     null: false
    t.integer  "carbohydrates",       limit: 4,   default: 0,     null: false
    t.string   "icon",                limit: 255, default: "",    null: false
    t.integer  "norm",                limit: 4,   default: 0,     null: false
    t.integer  "user_id",             limit: 4
    t.boolean  "is_public",           limit: 1,   default: false, null: false
    t.string   "photo_file_name",     limit: 255
    t.string   "photo_content_type",  limit: 255
    t.integer  "photo_file_size",     limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "name",        limit: 255,                null: false
    t.text     "description", limit: 65535
    t.text     "track",       limit: 65535
    t.string   "url",         limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id",   limit: 4
    t.integer  "user_id",     limit: 4
  end

  add_index "tracks", ["region_id"], name: "index_tracks_on_region_id", using: :btree
  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id", using: :btree

  create_table "trip_comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "trip_id",    limit: 4
    t.text     "comment",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trip_comments", ["trip_id"], name: "index_trip_comments_on_trip_id", using: :btree

  create_table "trip_users", force: :cascade do |t|
    t.integer "trip_id",  limit: 4
    t.integer "user_id",  limit: 4
    t.boolean "approved", limit: 1, default: false
  end

  add_index "trip_users", ["trip_id"], name: "index_trip_users_on_trip_id", using: :btree
  add_index "trip_users", ["user_id"], name: "index_trip_users_on_user_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.integer  "track_id",         limit: 4
    t.date     "start_date",                                     null: false
    t.date     "end_date",                                       null: false
    t.text     "trip_details",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
    t.string   "url",              limit: 255
    t.integer  "available_places", limit: 4,                     null: false
    t.boolean  "has_guide",        limit: 1,     default: false, null: false
    t.integer  "menu_id",          limit: 4
    t.integer  "cached_duration",  limit: 4
  end

  add_index "trips", ["start_date"], name: "index_trips_on_start_date", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.text     "about",            limit: 65535
    t.text     "experience",       limit: 65535
    t.text     "equipment",        limit: 65535
    t.text     "contacts",         limit: 65535
    t.text     "private_contacts", limit: 65535
    t.text     "private_info",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "email_hash",             limit: 255
    t.string   "authentication_token",   limit: 255
    t.string   "role",                   limit: 255
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

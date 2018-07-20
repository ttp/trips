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

ActiveRecord::Schema.define(version: 20180522160157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "map_markers", force: :cascade do |t|
    t.string "name"
    t.decimal "lat"
    t.decimal "lng"
    t.string "type"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_day_entities", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "day_id"
    t.integer "entity_type", null: false
    t.integer "entity_id", null: false
    t.integer "weight", default: 0, null: false
    t.integer "sort_order", default: 0, null: false
    t.string "custom_name"
    t.string "notes"
    t.index ["day_id"], name: "index_menu_day_entities_on_day_id"
  end

  create_table "menu_days", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "num"
    t.decimal "coverage", precision: 3, scale: 2, default: "0.0", null: false
    t.string "notes"
    t.index ["menu_id"], name: "index_menu_days_on_menu_id"
  end

  create_table "menu_dish_categories", id: :serial, force: :cascade do |t|
    t.hstore "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_dish_category_translations", id: :serial, force: :cascade do |t|
    t.integer "menu_dish_category_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["locale"], name: "index_menu_dish_category_translations_on_locale"
    t.index ["menu_dish_category_id"], name: "index_menu_dish_category_translations_on_menu_dish_category_id"
  end

  create_table "menu_dish_products", id: :serial, force: :cascade do |t|
    t.integer "dish_id"
    t.integer "product_id"
    t.integer "weight"
    t.integer "sort_order", default: 0, null: false
  end

  create_table "menu_dish_translations", id: :serial, force: :cascade do |t|
    t.integer "menu_dish_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.text "description"
    t.index ["locale"], name: "index_menu_dish_translations_on_locale"
    t.index ["menu_dish_id"], name: "index_menu_dish_translations_on_menu_dish_id"
  end

  create_table "menu_dishes", id: :serial, force: :cascade do |t|
    t.integer "dish_category_id"
    t.integer "user_id"
    t.boolean "is_public", default: false, null: false
    t.string "photo_file_name", limit: 255
    t.string "photo_content_type", limit: 255
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.hstore "name"
    t.hstore "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_meal_translations", id: :serial, force: :cascade do |t|
    t.integer "menu_meal_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["locale"], name: "index_menu_meal_translations_on_locale"
    t.index ["menu_meal_id"], name: "index_menu_meal_translations_on_menu_meal_id"
  end

  create_table "menu_meals", id: :serial, force: :cascade do |t|
    t.hstore "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_menus", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255, null: false
    t.string "read_key", limit: 255, null: false
    t.string "edit_key", limit: 255, null: false
    t.integer "users_count", default: 1, null: false
    t.integer "days_count", default: 0, null: false
    t.decimal "coverage", precision: 5, scale: 2, default: "0.0", null: false
    t.boolean "is_public", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.index ["is_public"], name: "index_menu_menus_on_is_public"
    t.index ["user_id"], name: "index_menu_menus_on_user_id"
  end

  create_table "menu_partition_porter_products", id: :serial, force: :cascade do |t|
    t.integer "partition_porter_id"
    t.integer "day_entity_id"
    t.index ["partition_porter_id"], name: "index_menu_partition_porter_products_on_partition_porter_id"
  end

  create_table "menu_partition_porters", id: :serial, force: :cascade do |t|
    t.integer "partition_id"
    t.integer "user_id"
    t.string "name", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["partition_id"], name: "index_menu_partition_porters_on_partition_id"
  end

  create_table "menu_partitions", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["menu_id"], name: "index_menu_partitions_on_menu_id"
  end

  create_table "menu_product_categories", id: :serial, force: :cascade do |t|
    t.hstore "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_product_category_translations", id: :serial, force: :cascade do |t|
    t.integer "menu_product_category_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["locale"], name: "index_menu_product_category_translations_on_locale"
    t.index ["menu_product_category_id"], name: "index_6680f3b847633177684d3ec6549dd62931982788"
  end

  create_table "menu_product_translations", id: :serial, force: :cascade do |t|
    t.integer "menu_product_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.text "description"
    t.text "norm_info"
    t.index ["locale"], name: "index_menu_product_translations_on_locale"
    t.index ["menu_product_id"], name: "index_menu_product_translations_on_menu_product_id"
  end

  create_table "menu_products", id: :serial, force: :cascade do |t|
    t.integer "product_category_id", null: false
    t.integer "calories", default: 0, null: false
    t.integer "proteins", default: 0, null: false
    t.integer "fats", default: 0, null: false
    t.integer "carbohydrates", default: 0, null: false
    t.integer "norm", default: 0, null: false
    t.integer "user_id"
    t.boolean "is_public", default: false, null: false
    t.string "photo_file_name", limit: 255
    t.string "photo_content_type", limit: 255
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.hstore "name"
    t.hstore "description"
    t.hstore "norm_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description", null: false
    t.text "track", null: false
    t.string "url", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.integer "user_id"
    t.index ["region_id"], name: "index_tracks_on_region_id"
    t.index ["user_id"], name: "index_tracks_on_user_id"
  end

  create_table "trip_comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "trip_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_trip_comments_on_trip_id"
  end

  create_table "trip_users", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "user_id"
    t.boolean "approved", default: false
    t.index ["trip_id"], name: "index_trip_users_on_trip_id"
    t.index ["user_id"], name: "index_trip_users_on_user_id"
  end

  create_table "trips", id: :serial, force: :cascade do |t|
    t.integer "track_id"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "trip_details", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "url", limit: 255
    t.integer "available_places", null: false
    t.boolean "has_guide", default: false, null: false
    t.integer "menu_id"
    t.integer "cached_duration"
    t.index ["start_date"], name: "index_trips_on_start_date"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "user_profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "about", null: false
    t.text "experience", null: false
    t.text "equipment", null: false
    t.text "contacts", null: false
    t.text "private_contacts", null: false
    t.text "private_info", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "encrypted_password", limit: 255, null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 255
    t.string "email_hash", limit: 255
    t.string "authentication_token", limit: 255
    t.string "role", limit: 255
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

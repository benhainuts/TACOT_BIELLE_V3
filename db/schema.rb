# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_09_01_130917) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.string "number_plate"
    t.date "first_registration_date"
    t.string "make"
    t.string "model"
    t.string "energy"
    t.integer "horsepower"
    t.integer "mileage"
    t.date "last_technical_control_date"
    t.date "last_maintenance_operation_made_on"
    t.string "last_maintenance_operation_mileage"
    t.date "created_on"
    t.date "modified_on"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mileage_per_year"
    t.string "use"
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "garage_stops", force: :cascade do |t|
    t.date "date"
    t.integer "mileage"
    t.bigint "car_id", null: false
    t.bigint "garage_id", null: false
    t.integer "cost"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_garage_stops_on_car_id"
    t.index ["garage_id"], name: "index_garage_stops_on_garage_id"
  end

  create_table "garages", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_data", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "invoice_number"
    t.string "number_plate"
    t.string "make"
    t.string "model"
    t.integer "mileage"
    t.string "energy"
    t.text "maintenance_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_image_data_on_user_id"
  end

  create_table "maintenance_items", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.string "item_name"
    t.integer "to_do_every_x_km"
    t.integer "to_do_every_x_years"
    t.boolean "one_shot_operation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_maintenance_items_on_car_id"
  end

  create_table "stop_items", force: :cascade do |t|
    t.bigint "maintenance_item_id", null: false
    t.bigint "garage_stop_id", null: false
    t.integer "price"
    t.date "next_date_milestone"
    t.integer "next_km_milestone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garage_stop_id"], name: "index_stop_items_on_garage_stop_id"
    t.index ["maintenance_item_id"], name: "index_stop_items_on_maintenance_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "users"
  add_foreign_key "garage_stops", "cars"
  add_foreign_key "garage_stops", "garages"
  add_foreign_key "image_data", "users"
  add_foreign_key "maintenance_items", "cars"
  add_foreign_key "stop_items", "garage_stops"
  add_foreign_key "stop_items", "maintenance_items"
end

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

ActiveRecord::Schema.define(version: 2021_04_10_102612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assmats", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "area"
    t.date "last_update"
    t.float "distance"
    t.string "phone"
    t.string "cell"
    t.string "general_availability"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "availabilities", force: :cascade do |t|
    t.string "description"
    t.string "details"
    t.string "calendar"
    t.bigint "assmat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assmat_id"], name: "index_availabilities_on_assmat_id"
  end

  create_table "user_inputs", force: :cascade do |t|
    t.boolean "selected"
    t.text "comment"
    t.bigint "assmat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assmat_id"], name: "index_user_inputs_on_assmat_id"
    t.index ["user_id"], name: "index_user_inputs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "assmats"
  add_foreign_key "user_inputs", "assmats"
  add_foreign_key "user_inputs", "users"
end

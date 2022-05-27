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

ActiveRecord::Schema.define(version: 2022_05_27_071810) do

  create_table "lab_orders", force: :cascade do |t|
    t.string "qrcode"
    t.string "blood_type"
    t.integer "patient_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tissue_name"
    t.string "requested_by"
    t.string "taken_by"
    t.index ["patient_id"], name: "index_lab_orders_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "dob"
    t.string "district"
    t.string "village"
    t.string "phone"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "result_archieves", force: :cascade do |t|
    t.string "patient_name"
    t.string "blood_type"
    t.float "temperature"
    t.string "name"
    t.integer "lab_order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lab_order_id"], name: "index_result_archieves_on_lab_order_id"
  end

  create_table "results", force: :cascade do |t|
    t.string "patient_name"
    t.string "blood_type"
    t.integer "lab_order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hiv_res"
    t.text "tisuue_res"
    t.string "conducted_by"
    t.index ["lab_order_id"], name: "index_results_on_lab_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "phone"
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "lab_orders", "patients"
  add_foreign_key "result_archieves", "lab_orders"
  add_foreign_key "results", "lab_orders"
end

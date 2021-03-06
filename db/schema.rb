# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_23_112301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "investments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity", null: false
    t.money "value_invested", scale: 2, null: false
    t.date "invested_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_investments_on_item_id"
    t.index ["user_id"], name: "index_investments_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "abbreviation", null: false
    t.string "name", null: false
    t.index ["abbreviation"], name: "index_items_on_abbreviation", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.decimal "low", precision: 10, scale: 2, null: false
    t.decimal "high", precision: 10, scale: 2, null: false
    t.date "date", null: false
    t.index ["item_id", "date"], name: "index_prices_on_item_id_and_date", unique: true
    t.index ["item_id"], name: "index_prices_on_item_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "delivered_at"
    t.json "payload", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "investments", "items"
  add_foreign_key "investments", "users"
  add_foreign_key "prices", "items"
  add_foreign_key "reports", "users"
end

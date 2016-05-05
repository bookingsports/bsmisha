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

ActiveRecord::Schema.define(version: 20160505132036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "number"
    t.string   "company"
    t.string   "inn"
    t.string   "kpp"
    t.string   "bik"
    t.string   "agreement_number"
    t.datetime "date"
    t.string   "accountable_type"
    t.integer  "accountable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "additional_event_items", force: :cascade do |t|
    t.integer  "related_id"
    t.string   "related_type"
    t.integer  "event_id"
    t.integer  "amount",       default: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "additional_event_items", ["event_id"], name: "index_additional_event_items_on_event_id", using: :btree
  add_index "additional_event_items", ["related_type", "related_id"], name: "index_additional_event_items_on_related_type_and_related_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.integer  "stadium_id"
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.decimal  "change_price", default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["stadium_id"], name: "index_areas_on_stadium_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "ancestry"
    t.string   "slug"
    t.string   "icon"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "coaches", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "slug"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "coaches", ["user_id"], name: "index_coaches_on_user_id", using: :btree

  create_table "coaches_areas", force: :cascade do |t|
    t.integer "coach_id"
    t.integer "area_id"
    t.decimal "price",           precision: 8, scale: 2, default: 0.0
    t.float   "stadium_percent",                         default: 0.0
    t.integer "status",                                  default: 0
  end

  add_index "coaches_areas", ["area_id"], name: "index_coaches_areas_on_area_id", using: :btree
  add_index "coaches_areas", ["coach_id"], name: "index_coaches_areas_on_coach_id", using: :btree

  create_table "daily_price_rules", force: :cascade do |t|
    t.integer  "price_id"
    t.time     "start"
    t.time     "stop"
    t.integer  "value"
    t.integer  "working_days", default: [],                 array: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "is_discount",  default: false
  end

  add_index "daily_price_rules", ["price_id"], name: "index_daily_price_rules_on_price_id", using: :btree

  create_table "deposit_requests", force: :cascade do |t|
    t.integer  "wallet_id"
    t.integer  "status",                                 default: 0
    t.decimal  "amount",         precision: 8, scale: 2
    t.text     "data"
    t.string   "uuid"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "payment_method",                         default: 0
  end

  add_index "deposit_requests", ["wallet_id"], name: "index_deposit_requests_on_wallet_id", using: :btree

  create_table "deposit_responses", force: :cascade do |t|
    t.integer  "deposit_request_id"
    t.integer  "status"
    t.text     "data"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "deposit_responses", ["deposit_request_id"], name: "index_deposit_responses_on_deposit_request_id", using: :btree

  create_table "deposits", force: :cascade do |t|
    t.integer  "wallet_id"
    t.integer  "status"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "deposits", ["wallet_id"], name: "index_deposits_on_wallet_id", using: :btree

  create_table "event_changes", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "order_id"
    t.datetime "old_start"
    t.datetime "old_stop"
    t.datetime "new_start"
    t.datetime "new_stop"
    t.float    "old_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_changes", ["event_id"], name: "index_event_changes_on_event_id", using: :btree
  add_index "event_changes", ["order_id"], name: "index_event_changes_on_order_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.datetime "start"
    t.datetime "stop"
    t.string   "description"
    t.integer  "coach_id"
    t.integer  "area_id"
    t.integer  "order_id"
    t.integer  "user_id"
    t.float    "price"
    t.string   "recurrence_rule"
    t.string   "recurrence_exception"
    t.integer  "recurrence_id"
    t.boolean  "is_all_day"
    t.integer  "status",               default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "confirmed",            default: false
  end

  add_index "events", ["area_id"], name: "index_events_on_area_id", using: :btree
  add_index "events", ["coach_id"], name: "index_events_on_coach_id", using: :btree
  add_index "events", ["order_id"], name: "index_events_on_order_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "events_stadium_services", force: :cascade do |t|
    t.integer "event_id"
    t.integer "stadium_service_id"
  end

  add_index "events_stadium_services", ["event_id"], name: "index_events_stadium_services_on_event_id", using: :btree
  add_index "events_stadium_services", ["stadium_service_id"], name: "index_events_stadium_services_on_stadium_service_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "total",      precision: 8, scale: 2
    t.integer  "status",                             default: 0
    t.string   "comment"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "pictures", ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree

  create_table "prices", force: :cascade do |t|
    t.datetime "start"
    t.datetime "stop"
    t.integer  "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "prices", ["area_id"], name: "index_prices_on_area_id", using: :btree

  create_table "recoupments", force: :cascade do |t|
    t.integer  "price"
    t.integer  "user_id"
    t.integer  "area_id"
    t.string   "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recoupments", ["area_id"], name: "index_recoupments_on_area_id", using: :btree
  add_index "recoupments", ["user_id"], name: "index_recoupments_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.text     "text"
    t.integer  "user_id"
    t.boolean  "verified"
    t.integer  "rating"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "reviews", ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stadium_services", force: :cascade do |t|
    t.integer  "stadium_id"
    t.integer  "service_id"
    t.float    "price"
    t.boolean  "periodic",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "stadium_services", ["service_id"], name: "index_stadium_services_on_service_id", using: :btree
  add_index "stadium_services", ["stadium_id"], name: "index_stadium_services_on_stadium_id", using: :btree

  create_table "stadiums", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "name",        default: "Без названия",        null: false
    t.string   "phone"
    t.string   "description"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug"
    t.integer  "status",      default: 0
    t.string   "email"
    t.string   "main_image"
    t.time     "opens_at",    default: '2000-01-01 07:00:00'
    t.time     "closes_at",   default: '2000-01-01 23:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stadiums", ["category_id"], name: "index_stadiums_on_category_id", using: :btree
  add_index "stadiums", ["user_id"], name: "index_stadiums_on_user_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.text     "text"
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "type",                   default: "Customer"
    t.string   "avatar"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  create_table "wallets", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id", using: :btree

  create_table "withdrawal_requests", force: :cascade do |t|
    t.integer  "wallet_id"
    t.integer  "status",                             default: 0
    t.decimal  "amount",     precision: 8, scale: 2
    t.text     "data"
    t.text     "payment"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "withdrawal_requests", ["wallet_id"], name: "index_withdrawal_requests_on_wallet_id", using: :btree

  create_table "withdrawals", force: :cascade do |t|
    t.integer  "wallet_id"
    t.integer  "status"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "withdrawals", ["wallet_id"], name: "index_withdrawals_on_wallet_id", using: :btree

  add_foreign_key "additional_event_items", "events"
  add_foreign_key "areas", "stadiums"
  add_foreign_key "coaches", "users"
  add_foreign_key "daily_price_rules", "prices"
  add_foreign_key "deposit_requests", "wallets"
  add_foreign_key "deposit_responses", "deposit_requests"
  add_foreign_key "deposits", "wallets"
  add_foreign_key "event_changes", "events"
  add_foreign_key "event_changes", "orders"
  add_foreign_key "events", "areas"
  add_foreign_key "events", "coaches"
  add_foreign_key "events", "orders"
  add_foreign_key "events", "users"
  add_foreign_key "events_stadium_services", "events"
  add_foreign_key "events_stadium_services", "stadium_services"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "areas"
  add_foreign_key "recoupments", "areas"
  add_foreign_key "recoupments", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "stadium_services", "services"
  add_foreign_key "stadium_services", "stadiums"
  add_foreign_key "stadiums", "categories"
  add_foreign_key "stadiums", "users"
  add_foreign_key "wallets", "users"
  add_foreign_key "withdrawal_requests", "wallets"
  add_foreign_key "withdrawals", "wallets"
end

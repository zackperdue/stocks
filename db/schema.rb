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

ActiveRecord::Schema.define(version: 20150814023026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "symbol"
    t.string   "name"
    t.float    "last_sale"
    t.float    "market_cap"
    t.string   "ipo_year"
    t.integer  "sector_id"
    t.string   "summary_quote"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "industry_id"
  end

  add_index "companies", ["industry_id"], name: "index_companies_on_industry_id", using: :btree
  add_index "companies", ["sector_id"], name: "index_companies_on_sector_id", using: :btree

  create_table "industries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.integer  "company_id"
    t.date     "date"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.integer  "volume"
    t.float    "adj_close"
    t.string   "interval"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "timestamp",  limit: 8
  end

  add_index "quotes", ["company_id"], name: "index_quotes_on_company_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

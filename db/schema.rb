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

ActiveRecord::Schema.define(version: 20160625121809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "facebook_id"
    t.string   "name"
    t.string   "page_URL"
    t.integer  "gender"
    t.integer  "type"
    t.integer  "style"
    t.integer  "price"
    t.integer  "music"
    t.integer  "mood"
    t.integer  "personality"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "brand_id"
    t.boolean  "match"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "facebook_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.integer  "type"
    t.integer  "style"
    t.integer  "price"
    t.integer  "music"
    t.integer  "mood"
    t.integer  "personality"
  end

end

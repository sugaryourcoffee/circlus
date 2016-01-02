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

ActiveRecord::Schema.define(version: 20160102152217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups_members", id: false, force: :cascade do |t|
    t.integer "group_id",  null: false
    t.integer "member_id", null: false
  end

  add_index "groups_members", ["group_id", "member_id"], name: "index_groups_members_on_group_id_and_member_id", using: :btree
  add_index "groups_members", ["member_id", "group_id"], name: "index_groups_members_on_member_id_and_group_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "first_name",      null: false
    t.date     "date_of_birth"
    t.string   "phone"
    t.string   "email"
    t.text     "information"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "street",      null: false
    t.string   "zip",         null: false
    t.string   "town",        null: false
    t.string   "country",     null: false
    t.string   "email"
    t.string   "website"
    t.text     "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "phone"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

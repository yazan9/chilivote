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

ActiveRecord::Schema.define(version: 20150405110058) do

  create_table "answers", force: true do |t|
    t.string   "name"
    t.integer  "cvote_id"
    t.string   "image_id"
    t.integer  "likes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.string   "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["active"], name: "index_categories_on_active"
  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "comments", force: true do |t|
    t.integer  "cvote_id"
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iso_two_letter_code"
  end

  create_table "cvote_trackers", force: true do |t|
    t.integer  "user_id"
    t.integer  "cvote_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cvotes", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "notification_type"
    t.integer  "user_me"
    t.integer  "user_friend"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewed",            default: false
  end

  create_table "polls", force: true do |t|
    t.text     "topic"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polls", ["user_id"], name: "index_polls_on_user_id"

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "votes"
    t.string   "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: false
  end

  add_index "posts", ["active"], name: "index_posts_on_active"
  add_index "posts", ["category_id"], name: "index_posts_on_category_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "pvotes", force: true do |t|
    t.integer  "user_id"
    t.integer  "vote_option_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pvotes", ["poll_id"], name: "index_pvotes_on_poll_id"
  add_index "pvotes", ["user_id"], name: "index_pvotes_on_user_id"
  add_index "pvotes", ["vote_option_id", "user_id"], name: "index_pvotes_on_vote_option_id_and_user_id", unique: true
  add_index "pvotes", ["vote_option_id"], name: "index_pvotes_on_vote_option_id"

  create_table "statuses", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "status_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id"

  create_table "svotes", force: true do |t|
    t.integer  "status_id"
    t.integer  "user_id"
    t.integer  "svote_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.string   "profile_image"
    t.date     "dob"
    t.integer  "country_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "vote_options", force: true do |t|
    t.string   "title"
    t.integer  "poll_id"
    t.boolean  "correct_answer", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vote_options", ["poll_id"], name: "index_vote_options_on_poll_id"

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["category_id"], name: "index_votes_on_category_id"
  add_index "votes", ["post_id"], name: "index_votes_on_post_id"
  add_index "votes", ["user_id", "post_id"], name: "index_votes_on_user_id_and_post_id", unique: true
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end

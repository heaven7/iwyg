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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120615152528) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "has_taken"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "customs", :force => true do |t|
    t.integer  "customable_id"
    t.string   "customable_type"
    t.boolean  "deleted"
    t.boolean  "visible"
    t.boolean  "enable"
    t.string   "background"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.datetime "from"
    t.datetime "till"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "ping_id"
    t.text     "description"
    t.integer  "status",         :default => 1
  end

  create_table "folders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "accepted_at"
  end

  create_table "groupings", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groupings", ["group_id", "user_id"], :name => "index_groups_users_on_group_id_and_user_id"
  add_index "groupings", ["user_id", "group_id"], :name => "index_groups_users_on_user_id_and_group_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "item_attachments", :force => true do |t|
    t.integer  "attachment_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "meetup_id"
  end

  create_table "item_statuses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_types", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category"
    t.integer  "user_id"
    t.boolean  "need",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_type_id"
    t.boolean  "multiple",     :default => false
    t.datetime "from"
    t.datetime "till"
    t.float    "amount"
    t.integer  "measure_id"
    t.integer  "status",       :default => 1
  end

  create_table "locations", :force => true do |t|
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "gmaps"
  end

  create_table "measures", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", :force => true do |t|
    t.integer  "meetup_id"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted"
    t.datetime "accepted_at"
  end

  create_table "meetups", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "owner_id"
    t.string   "ownertype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "message_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "read"
  end

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "read"
  end

  create_table "pings", :force => true do |t|
    t.integer  "pingable_id"
    t.string   "pingable_type"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
    t.integer  "associated_id"
    t.string   "associated_type"
  end

  create_table "rates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars"
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id"], :name => "index_rates_on_rateable_id"
  add_index "rates", ["user_id"], :name => "index_rates_on_user_id"

  create_table "resources", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "status"
    t.integer  "category"
    t.integer  "user_id"
    t.boolean  "need",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "keyword"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "statuses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "transfer_options", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "transferable_id"
    t.string   "transferable_type"
    t.integer  "status",            :default => 1
    t.integer  "user_id"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receiverable_id"
    t.string   "receiverable_type"
    t.integer  "pinger"
  end

  create_table "userdetails", :force => true do |t|
    t.integer  "user_id"
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "birthdate"
    t.string   "occupation"
    t.string   "company"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "rpx_identifier"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end

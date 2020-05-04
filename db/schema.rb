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

ActiveRecord::Schema.define(version: 2020_05_04_084917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_items", force: :cascade do |t|
    t.string "name", null: false
    t.string "amount"
    t.bigint "calory"
    t.bigint "meal_post_id", null: false
    t.index ["meal_post_id"], name: "index_food_items_on_meal_post_id"
  end

  create_table "meal_posts", force: :cascade do |t|
    t.text "content"
    t.datetime "time"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_calories"
    t.integer "food_items_count", default: 0, null: false
    t.integer "food_items_with_calories_count", default: 0, null: false
    t.index ["user_id"], name: "index_meal_posts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "account_id", null: false
    t.string "name", null: false
    t.string "encrypted_password"
    t.boolean "is_male"
    t.float "height"
    t.float "weight"
    t.text "comment"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.index ["account_id"], name: "index_users_on_account_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "meal_post_id", null: false
    t.boolean "is_upvote", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["meal_post_id"], name: "index_votes_on_meal_post_id"
    t.index ["user_id", "meal_post_id"], name: "index_votes_on_user_id_and_meal_post_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "food_items", "meal_posts"
  add_foreign_key "meal_posts", "users"
  add_foreign_key "votes", "meal_posts"
  add_foreign_key "votes", "users"
end

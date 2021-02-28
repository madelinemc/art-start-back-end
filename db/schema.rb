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

ActiveRecord::Schema.define(version: 2021_02_28_192512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "artworks", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "artist_id", null: false
    t.integer "met_identifier"
    t.boolean "highlight"
    t.string "primary_image_small"
    t.string "primary_image"
    t.string "name"
    t.string "title"
    t.string "culture"
    t.string "period"
    t.string "date"
    t.string "medium"
    t.float "height"
    t.float "width"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "depth"
    t.index ["artist_id"], name: "index_artworks_on_artist_id"
    t.index ["department_id"], name: "index_artworks_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "artworks", "artists"
  add_foreign_key "artworks", "departments"
end

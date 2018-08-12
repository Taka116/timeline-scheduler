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

ActiveRecord::Schema.define(version: 2018_08_07_011038) do

  create_table "univ_class_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "univ_class_id"
    t.string "day"
    t.string "period"
    t.string "classroom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["univ_class_id"], name: "index_univ_class_details_on_univ_class_id"
  end

  create_table "univ_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "class_code"
    t.string "subject_name"
    t.string "professor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["class_code", "subject_name", "professor"], name: "index_univ_classes_on_class_code_and_subject_name_and_professor"
    t.index ["user_id"], name: "index_univ_classes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "univ_class_details", "univ_classes"
  add_foreign_key "univ_classes", "users"
end

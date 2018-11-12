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

ActiveRecord::Schema.define(version: 2018_11_06_233746) do

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "univ_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["univ_class_id"], name: "index_likes_on_univ_class_id"
    t.index ["user_id", "univ_class_id"], name: "index_likes_on_user_id_and_univ_class_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

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
    t.string "class_code", null: false
    t.string "subject_name", null: false
    t.string "professor", null: false
    t.integer "level"
    t.integer "number_of_credit", null: false
    t.string "class_url", null: false
    t.text "content_of_class"
    t.text "exam_evaluation"
    t.text "report_evaluation"
    t.text "normal_evaluation"
    t.text "other_evaluation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["class_code", "subject_name", "professor"], name: "index_univ_classes_on_class_code_and_subject_name_and_professor"
    t.index ["user_id"], name: "index_univ_classes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "likes", "univ_classes"
  add_foreign_key "likes", "users"
  add_foreign_key "univ_class_details", "univ_classes"
  add_foreign_key "univ_classes", "users"
end

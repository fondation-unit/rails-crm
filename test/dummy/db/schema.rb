# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_28_084240) do
  create_table "crm_disciplines", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crm_investments", force: :cascade do |t|
    t.string "name", null: false
    t.string "referent1", null: false
    t.string "referent2", null: false
    t.string "copy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crm_levels", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crm_member_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crm_members", force: :cascade do |t|
    t.string "gender"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email_address", null: false
    t.string "position"
    t.string "phone_number"
    t.boolean "copil"
    t.boolean "comex"
    t.boolean "decisionnaire"
    t.boolean "principal"
    t.string "linkedin"
    t.boolean "linkedin_connected"
    t.boolean "newsletter_ressources"
    t.boolean "invest"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_crm_members_on_email_address", unique: true
  end

  create_table "crm_members_disciplines", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "discipline_id", null: false
    t.index ["discipline_id", "member_id"], name: "index_crm_members_disciplines_on_discipline_id_and_member_id"
    t.index ["member_id", "discipline_id"], name: "index_crm_members_disciplines_on_member_id_and_discipline_id"
  end

  create_table "crm_members_investments", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "investment_id", null: false
    t.index ["investment_id", "member_id"], name: "index_crm_members_investments_on_investment_id_and_member_id"
    t.index ["member_id", "investment_id"], name: "index_crm_members_investments_on_member_id_and_investment_id"
  end

  create_table "crm_members_levels", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "level_id", null: false
    t.index ["level_id", "member_id"], name: "index_crm_members_levels_on_level_id_and_member_id"
    t.index ["member_id", "level_id"], name: "index_crm_members_levels_on_member_id_and_level_id"
  end

  create_table "crm_members_member_types", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "member_type_id", null: false
    t.index ["member_id", "member_type_id"], name: "index_crm_members_member_types_on_member_id_and_member_type_id"
    t.index ["member_type_id", "member_id"], name: "index_crm_members_member_types_on_member_type_id_and_member_id"
  end

  create_table "crm_members_organizations", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "organization_id", null: false
    t.index ["member_id", "organization_id"], name: "idx_on_member_id_organization_id_23f5598316"
    t.index ["organization_id", "member_id"], name: "idx_on_organization_id_member_id_15105e7492"
  end

  create_table "crm_notes", force: :cascade do |t|
    t.boolean "public", default: false
    t.string "contact_type"
    t.integer "user_id"
    t.string "notable_type", null: false
    t.integer "notable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_crm_notes_on_notable"
    t.index ["user_id"], name: "index_crm_notes_on_user_id"
  end

  create_table "crm_organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.float "lat"
    t.float "lng"
    t.string "linkedin"
    t.boolean "linkedin_connected", default: false, null: false
    t.integer "status"
    t.string "type_orga"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_crm_organizations_on_name", unique: true
    t.index ["user_id"], name: "index_crm_organizations_on_user_id"
  end

  add_foreign_key "crm_members_disciplines", "crm_disciplines", column: "discipline_id"
  add_foreign_key "crm_members_disciplines", "crm_members", column: "member_id"
  add_foreign_key "crm_members_investments", "crm_investments", column: "investment_id"
  add_foreign_key "crm_members_investments", "crm_members", column: "member_id"
  add_foreign_key "crm_members_levels", "crm_levels", column: "level_id"
  add_foreign_key "crm_members_levels", "crm_members", column: "member_id"
  add_foreign_key "crm_members_member_types", "crm_member_types", column: "member_type_id"
  add_foreign_key "crm_members_member_types", "crm_members", column: "member_id"
  add_foreign_key "crm_members_organizations", "crm_members", column: "member_id"
  add_foreign_key "crm_members_organizations", "crm_organizations", column: "organization_id"
end

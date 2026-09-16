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

ActiveRecord::Schema[8.0].define(version: 2026_08_18_123640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "investments", force: :cascade do |t|
    t.string "name", null: false
    t.string "referent1", null: false
    t.string "referent2", null: false
    t.string "copy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_types_members", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "member_type_id", null: false
    t.index ["member_id", "member_type_id"], name: "index_member_types_members_on_member_id_and_member_type_id"
    t.index ["member_type_id", "member_id"], name: "index_member_types_members_on_member_type_id_and_member_id"
  end

  create_table "members", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('simple'::regconfig, (((((((COALESCE(first_name, ''::character varying))::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text) || ' '::text) || (COALESCE(\"position\", ''::character varying))::text) || ' '::text) || (COALESCE(email_address, ''::character varying))::text))", stored: true
    t.index ["email_address"], name: "index_members_on_email_address", unique: true
    t.index ["search_vector"], name: "index_members_on_search_vector", using: :gin
  end

  create_table "members_investments", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "investment_id", null: false
    t.index ["investment_id", "member_id"], name: "index_members_investments_on_investment_id_and_member_id"
    t.index ["member_id", "investment_id"], name: "index_members_investments_on_member_id_and_investment_id"
  end

  create_table "members_organizations", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "organization_id", null: false
    t.index ["member_id", "organization_id"], name: "index_members_organizations_on_member_id_and_organization_id"
    t.index ["organization_id", "member_id"], name: "index_members_organizations_on_organization_id_and_member_id"
  end

  create_table "notes", force: :cascade do |t|
    t.boolean "public", default: false
    t.string "contact_type"
    t.bigint "user_id"
    t.string "notable_type", null: false
    t.bigint "notable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
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
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('simple'::regconfig, (((((COALESCE(name, ''::character varying))::text || ' '::text) || (COALESCE(city, ''::character varying))::text) || ' '::text) || (COALESCE(address, ''::character varying))::text))", stored: true
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["search_vector"], name: "index_organizations_on_search_vector", using: :gin
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end

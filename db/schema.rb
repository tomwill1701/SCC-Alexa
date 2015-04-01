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

ActiveRecord::Schema.define(version: 20150325211513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "cgroups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "cload_items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "source"
    t.string   "member"
    t.text     "model"
    t.string   "keys"
    t.string   "ctype"
    t.string   "cclass"
    t.string   "tags"
    t.string   "prompts"
    t.string   "size"
    t.string   "chart_type"
    t.string   "chart_x"
    t.string   "chart_y"
    t.text     "chart_opt"
    t.string   "status"
    t.string   "group"
    t.string   "preload"
    t.integer  "cache_time"
    t.integer  "cload_id"
    t.integer  "command_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cloads", force: :cascade do |t|
    t.string   "dsname"
    t.string   "volser"
    t.integer  "lpar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cloads", ["lpar_id"], name: "index_cloads_on_lpar_id", using: :btree

  create_table "command_cgroups", force: :cascade do |t|
    t.integer  "command_id"
    t.integer  "cgroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "command_cgroups", ["cgroup_id"], name: "index_command_cgroups_on_cgroup_id", using: :btree
  add_index "command_cgroups", ["command_id"], name: "index_command_cgroups_on_command_id", using: :btree

  create_table "command_restricts", force: :cascade do |t|
    t.integer  "cgroup_id"
    t.integer  "ugroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "command_restricts", ["cgroup_id"], name: "index_command_restricts_on_cgroup_id", using: :btree
  add_index "command_restricts", ["ugroup_id"], name: "index_command_restricts_on_ugroup_id", using: :btree

  create_table "commands", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "ctype"
    t.text     "model"
    t.string   "prompts"
    t.string   "source"
    t.string   "member"
    t.string   "keys"
    t.string   "size"
    t.string   "chart_type"
    t.string   "chart_x"
    t.string   "chart_y"
    t.text     "chart_opt"
    t.string   "cclass"
    t.string   "tags"
    t.string   "preload"
    t.integer  "cache_time",  default: 0
    t.text     "rscript"
    t.text     "vscript"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",         default: 0, null: false
    t.integer  "attempts",         default: 0, null: false
    t.text     "handler",                      null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "progress_stage"
    t.integer  "progress_current", default: 0
    t.integer  "progress_max",     default: 0
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "job_items", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "lgroup_id"
    t.integer  "cgroup_id"
    t.string   "size"
    t.string   "chart_type"
    t.string   "chart_x"
    t.string   "chart_y"
    t.string   "chart_opt"
    t.string   "racf_password"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name"
    t.string   "jtype"
    t.text     "description"
    t.string   "menu"
    t.string   "cclass"
    t.string   "tags"
    t.string   "when"
    t.string   "when_time"
    t.string   "run_type"
    t.integer  "keep_days"
    t.boolean  "private",      default: false
    t.boolean  "notify",       default: true
    t.boolean  "notify_group", default: true
    t.boolean  "cache",        default: true
    t.integer  "owner_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "lgroups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "sysplex",     default: false
    t.boolean  "private",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "lpar_lgroups", force: :cascade do |t|
    t.integer  "lpar_id"
    t.integer  "lgroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lpar_lgroups", ["lgroup_id"], name: "index_lpar_lgroups_on_lgroup_id", using: :btree
  add_index "lpar_lgroups", ["lpar_id"], name: "index_lpar_lgroups_on_lpar_id", using: :btree

  create_table "lpar_restricts", force: :cascade do |t|
    t.integer  "lgroup_id"
    t.integer  "ugroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lpar_restricts", ["lgroup_id"], name: "index_lpar_restricts_on_lgroup_id", using: :btree
  add_index "lpar_restricts", ["ugroup_id"], name: "index_lpar_restricts_on_ugroup_id", using: :btree

  create_table "lpars", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "ip"
    t.integer  "port"
    t.string   "location"
    t.string   "zos_release"
    t.string   "subsystems"
    t.string   "monproc"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "notices", force: :cascade do |t|
    t.text     "title"
    t.integer  "ugroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notices", ["ugroup_id"], name: "index_notices_on_ugroup_id", using: :btree

  create_table "run_commands", force: :cascade do |t|
    t.text     "model"
    t.text     "rtext"
    t.boolean  "done",          default: false
    t.boolean  "error",         default: false
    t.boolean  "add_lpar",      default: false
    t.string   "error_text"
    t.string   "status"
    t.string   "source"
    t.datetime "data_acquired"
    t.integer  "run_id"
    t.integer  "lpar_id"
    t.integer  "command_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "run_commands", ["command_id"], name: "index_run_commands_on_command_id", using: :btree
  add_index "run_commands", ["lpar_id"], name: "index_run_commands_on_lpar_id", using: :btree
  add_index "run_commands", ["run_id"], name: "index_run_commands_on_run_id", using: :btree

  create_table "run_views", force: :cascade do |t|
    t.string   "type"
    t.string   "file"
    t.string   "file_type"
    t.integer  "run_command_id"
    t.integer  "command_id"
    t.integer  "job_item_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "run_views", ["command_id"], name: "index_run_views_on_command_id", using: :btree
  add_index "run_views", ["job_item_id"], name: "index_run_views_on_job_item_id", using: :btree
  add_index "run_views", ["run_command_id"], name: "index_run_views_on_run_command_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.boolean  "background", default: true
    t.boolean  "cache",      default: true
    t.boolean  "error",      default: false
    t.boolean  "done",       default: false
    t.boolean  "notify",     default: false
    t.string   "status"
    t.string   "error_text"
    t.text     "log"
    t.integer  "total_data"
    t.datetime "start"
    t.datetime "end"
    t.datetime "viewed"
    t.datetime "delete_at"
    t.integer  "ugroup_id"
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "runs", ["job_id"], name: "index_runs_on_job_id", using: :btree
  add_index "runs", ["ugroup_id"], name: "index_runs_on_ugroup_id", using: :btree
  add_index "runs", ["user_id"], name: "index_runs_on_user_id", using: :btree

  create_table "ugroups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "racf_group"
    t.boolean  "private",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "user_jobs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  add_index "user_jobs", ["job_id"], name: "index_user_jobs_on_job_id", using: :btree
  add_index "user_jobs", ["user_id"], name: "index_user_jobs_on_user_id", using: :btree

  create_table "user_ugroups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ugroup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_ugroups", ["ugroup_id"], name: "index_user_ugroups_on_ugroup_id", using: :btree
  add_index "user_ugroups", ["user_id"], name: "index_user_ugroups_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "department"
    t.string   "phone"
    t.string   "email"
    t.string   "racf_userid"
    t.string   "racf_group"
    t.string   "racf_password"
    t.boolean  "admin",           default: false
    t.string   "password_digest"
    t.datetime "last_login"
    t.integer  "login_count",     default: 0
    t.string   "background"
    t.string   "notify"
    t.string   "cache"
    t.string   "prompt_ok"
    t.string   "prompt_cancel"
    t.string   "prompt_values"
    t.string   "prompt_fields"
    t.integer  "lpar_id"
    t.integer  "command_id"
    t.integer  "job_id"
    t.integer  "ugroup_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["command_id"], name: "index_users_on_command_id", using: :btree
  add_index "users", ["job_id"], name: "index_users_on_job_id", using: :btree
  add_index "users", ["lpar_id"], name: "index_users_on_lpar_id", using: :btree
  add_index "users", ["ugroup_id"], name: "index_users_on_ugroup_id", using: :btree

  add_foreign_key "cload_items", "cloads"
  add_foreign_key "cload_items", "commands"
  add_foreign_key "cloads", "lpars"
  add_foreign_key "command_cgroups", "cgroups"
  add_foreign_key "command_cgroups", "commands"
  add_foreign_key "command_restricts", "cgroups"
  add_foreign_key "command_restricts", "ugroups"
  add_foreign_key "job_items", "jobs"
  add_foreign_key "lpar_lgroups", "lgroups"
  add_foreign_key "lpar_lgroups", "lpars"
  add_foreign_key "lpar_restricts", "lgroups"
  add_foreign_key "lpar_restricts", "ugroups"
  add_foreign_key "notices", "ugroups"
  add_foreign_key "run_commands", "commands"
  add_foreign_key "run_commands", "lpars"
  add_foreign_key "run_commands", "runs"
  add_foreign_key "run_views", "commands"
  add_foreign_key "run_views", "job_items"
  add_foreign_key "run_views", "run_commands"
  add_foreign_key "user_jobs", "jobs"
  add_foreign_key "user_jobs", "users"
  add_foreign_key "user_ugroups", "ugroups"
  add_foreign_key "user_ugroups", "users"
  add_foreign_key "users", "lpars"
end

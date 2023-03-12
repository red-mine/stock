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

ActiveRecord::Schema[7.0].define(version: 20230314) do
  create_table "stave_staves", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
  end

  create_table "stocks_bolls_lohas", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks_bolls_years", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks_coefs_lohas", force: :cascade do |t|
    t.string "stock"
    t.float "coef"
    t.float "inter"
    t.float "price"
    t.boolean "good"
    t.string "stave"
    t.integer "boll"
    t.integer "stav"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks_coefs_stavs", force: :cascade do |t|
    t.string "stock"
    t.float "loha"
    t.float "year"
    t.float "price"
    t.boolean "good"
    t.string "lohas"
    t.string "years"
    t.integer "boll3"
    t.integer "stav3"
    t.integer "boll1"
    t.integer "stav1"
    t.date "date"
  end

  create_table "stocks_coefs_years", force: :cascade do |t|
    t.string "stock"
    t.float "coef"
    t.float "inter"
    t.float "price"
    t.boolean "good"
    t.string "stave"
    t.integer "boll"
    t.integer "stav"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks_stave_lohas", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
    t.integer "years"
  end

  create_table "stocks_stave_years", force: :cascade do |t|
    t.string "stock"
    t.float "price"
    t.date "date"
    t.integer "years"
  end

end

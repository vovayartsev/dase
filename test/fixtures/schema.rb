ActiveRecord::Schema.define do

  create_table "authors", :force => true do |t|
    t.string "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "books", :force => true do |t|
    t.integer "year"
    t.string "title"
    t.integer "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
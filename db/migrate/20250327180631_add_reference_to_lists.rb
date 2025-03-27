class AddReferenceToLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :books, :book_lists, null: false, foreign_key: true
  end
end

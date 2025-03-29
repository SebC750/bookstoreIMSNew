class AddReferenceUserToBookList < ActiveRecord::Migration[8.0]
  def change
    add_reference :book_lists, :user, null: false, foreign_key: true
  end
end

class CreateBookLists < ActiveRecord::Migration[8.0]
  def change
    create_table :book_lists do |t|
      t.string :title

      t.timestamps
    end
  end
end

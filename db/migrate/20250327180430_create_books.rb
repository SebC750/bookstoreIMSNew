class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :bookTitle
      t.string :author
      t.text :description
      t.decimal :price
      
      t.timestamps
    end
  end
end

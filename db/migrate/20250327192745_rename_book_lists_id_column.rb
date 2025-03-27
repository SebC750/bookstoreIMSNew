class RenameBookListsIdColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :books, :book_lists_id, :book_list_id
  end
end

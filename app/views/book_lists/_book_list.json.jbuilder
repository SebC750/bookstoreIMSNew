json.extract! book_list, :id, :title, :created_at, :updated_at
json.url book_list_url(book_list, format: :json)

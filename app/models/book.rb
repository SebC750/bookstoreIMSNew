class Book < ApplicationRecord
    validates :bookTitle, :author, :description, :price, presence: { message: "Please complete the form." }
    belongs_to :book_list
end

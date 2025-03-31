require 'rails_helper'

RSpec.describe Book, type: :model do
  context "Incomplete form data for book" do
    it "Is missing a book title" do
      book = Book.new(author: "test", description: "description", price: 10)
      expect(book).not_to be_valid
      expect(book.errors[:bookTitle]).to include("Please complete the form.")
    end
    it "Is missing an author" do
      book = Book.new(bookTitle: "My book",  description: "description", price: 10)
      expect(book).not_to be_valid
      expect(book.errors[:author]).to include("Please complete the form.")
    end
    it "Is missing a book description" do
      book = Book.new(bookTitle: "My book", author: "test",  price: 10)
      expect(book).not_to be_valid
      expect(book.errors[:description]).to include("Please complete the form.")
    end
    it "Is missing a price" do
      book = Book.new(bookTitle: "My book", author: "test", description: "description")
      expect(book).not_to be_valid
      expect(book.errors[:price]).to include("Please complete the form.")
    end
  end
  context "Data type validation for form input" do
    it "receives a price in decimal format." do
      book = Book.new(bookTitle: "My book", author: "test", description: "description", price: 10)
      expect(book.price.is_a? BigDecimal).to eq(true)
    end
  end
end

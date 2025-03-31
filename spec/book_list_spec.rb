require 'rails_helper'

RSpec.describe BookList, type: :model do
  context "Invalid parameters for new booklist metadata" do
    it "has an invalid title input" do
      user = build(:user)
      book_list = BookList.new(title: "1", listDescription: "test", user: user)
      expect(book_list).not_to be_valid
      expect(book_list.errors[:title]).to include("Input must be a string.")
    end
    it "has an invalid description input" do
      user = build(:user)
      book_list = BookList.new(title: "title", listDescription: "2", user: user)
      expect(book_list).not_to be_valid
      expect(book_list.errors[:listDescription]).to include("Input must be a string.")
    end
  end

  context "Enters book list metadata successfully" do
    it "Enters the book list data successfully" do
      user = build(:user)
      book_list = BookList.new(title: "title", listDescription: "description", user: user)
      expect(book_list).to be_valid
    end
    it "Is invalid due to missing title" do
      book_list = BookList.new(listDescription: "description")
      expect(book_list).not_to be_valid
      expect(book_list.errors[:title]).to include("Please include the title.")
    end
    it "Is invalid due to missing description" do
      book_list = BookList.new(title: "A title")
      expect(book_list).not_to be_valid
      expect(book_list.errors[:listDescription]).to include("Please include the list description.")
    end
  end
end

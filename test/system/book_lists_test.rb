require "application_system_test_case"

class BookListsTest < ApplicationSystemTestCase
  setup do
    @book_list = book_lists(:one)
  end

  test "visiting the index" do
    visit book_lists_url
    assert_selector "h1", text: "Book lists"
  end

  test "should create book list" do
    visit book_lists_url
    click_on "New book list"

    fill_in "Title", with: @book_list.title
    click_on "Create Book list"

    assert_text "Book list was successfully created"
    click_on "Back"
  end

  test "should update Book list" do
    visit book_list_url(@book_list)
    click_on "Edit this book list", match: :first

    fill_in "Title", with: @book_list.title
    click_on "Update Book list"

    assert_text "Book list was successfully updated"
    click_on "Back"
  end

  test "should destroy Book list" do
    visit book_list_url(@book_list)
    click_on "Destroy this book list", match: :first

    assert_text "Book list was successfully destroyed"
  end
end

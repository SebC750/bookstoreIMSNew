require "test_helper"

class BookListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_list = book_lists(:one)
  end

  test "should get index" do
    get book_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_book_list_url
    assert_response :success
  end

  test "should create book_list" do
    assert_difference("BookList.count") do
      post book_lists_url, params: { book_list: { title: @book_list.title } }
    end

    assert_redirected_to book_list_url(BookList.last)
  end

  test "should show book_list" do
    get book_list_url(@book_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_list_url(@book_list)
    assert_response :success
  end

  test "should update book_list" do
    patch book_list_url(@book_list), params: { book_list: { title: @book_list.title } }
    assert_redirected_to book_list_url(@book_list)
  end

  test "should destroy book_list" do
    assert_difference("BookList.count", -1) do
      delete book_list_url(@book_list)
    end

    assert_redirected_to book_lists_url
  end
end

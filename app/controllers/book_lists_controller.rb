class BookListsController < ApplicationController
  before_action :set_book_list, only: %i[ show edit update destroy ]

  # GET /book_lists or /book_lists.json
  def index
    @book_lists = BookList.all
  end

  # GET /book_lists/1 or /book_lists/1.json
  def show
    @book_lists = BookList.all
    @books = @book_lists.books
  end

  # GET /book_lists/new
  def new
    @book_list = BookList.new
  end

  # GET /book_lists/1/edit
  def edit
  end

  # POST /book_lists or /book_lists.json
  def create
    @book_list = BookList.new(book_list_params)

    respond_to do |format|
      if @book_list.save
        format.html { redirect_to @book_list, notice: "Book list was successfully created." }
        format.json { render :show, status: :created, location: @book_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_lists/1 or /book_lists/1.json
  def update
    respond_to do |format|
      if @book_list.update(book_list_params)
        format.html { redirect_to @book_list, notice: "Book list was successfully updated." }
        format.json { render :show, status: :ok, location: @book_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_lists/1 or /book_lists/1.json
  def destroy
    @book_list.destroy!

    respond_to do |format|
      format.html { redirect_to book_lists_path, status: :see_other, notice: "Book list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_list
      @book_list = BookList.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_list_params
      params.expect(book_list: [ :title ])
    end
end

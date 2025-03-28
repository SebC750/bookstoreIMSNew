class BooksController < ApplicationController
  before_action :set_book_list
  before_action :set_book, only: [:edit, :update, :destroy]

  # GET /books/new
  def new
    @book = @book_list.books.build
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = @book_list.books.build(book_params)
    if @book.save
      redirect_to @book_list, notice: 'Book was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book_list, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to book_list_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_list
      @book_list = BookList.find(params[:book_list_id])
    end
    def set_book
    @book = @book_list.books.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Book not found."
    redirect_to book_list_path(@book_list)
  end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:bookTitle, :author, :description, :price )
    end
end

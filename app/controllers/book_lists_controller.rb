class BookListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book_list, only: %i[ show edit update destroy ]
  # GET /book_lists or /book_lists.json
  def index
    @list_pagy, @book_lists = pagy(current_user.book_lists, items: 9)
  end

  # GET /book_lists/1 or /book_lists/1.json
  def show
    @book_list = current_user.book_lists.find(params[:id])
    @book_pagy, @books = pagy(@book_list.books, items: 10)
  end

  # GET /book_lists/new
  def new
    @book_list = current_user.book_lists.new
  end

  # GET /book_lists/1/edit
  def edit
  end

  # POST /book_lists or /book_lists.json
  def create
    @book_list = current_user.book_lists.new(book_list_params)
    if @book_list.title =~ /\A\d+\z/
      flash.now[:alert] = "Please enter a valid string for the list title, not a number."
      render :new and return
    end
    if @book_list.listDescription =~ /\A\d+\z/
      flash.now[:alert] = "Please enter a valid string for the list description, not a number."
      render :new and return
    end
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
      @book_list = current_user.book_lists.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_list_params
      params.require(:book_list).permit(:title, :listDescription)
    end
end

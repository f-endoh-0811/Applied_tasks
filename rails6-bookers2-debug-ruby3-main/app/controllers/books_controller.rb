class BooksController < ApplicationController
  before_action :book_find, only: [:edit, :update, :destroy]

  def show
    @book_find = Book.find(params[:id])
    @book = Book.new
    @comment = BookComment.new
  end

  def index
    @books = Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    if @book.user_id != current_user.id
      redirect_to book_path(@book)
    end
  end

  def update
    if @book.user_id == current_user.id
      @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    if @book.user_id == current_user.id
      @book.destroy
      redirect_to books_path
    else
      render "show"
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def book_find
    @book = Book.find(params[:id])
  end
end

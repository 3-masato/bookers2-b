class BooksController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |e|
    redirect_to books_path
  end

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    @books = Book.all
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def posted_counts
    user = User.find(params[:user_id])
    books = user.books

    date_range = 0..6

    data = books.post_dates(date_range)
    labels = date_range.map { |n| n == 0 ? "Today" : "#{n} days ago" }.reverse

    render json: {
      data: data,
      labels: labels
    }
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    user = Book.find(params[:id]).user
    unless user == current_user
      redirect_to books_path
    end
  end
end

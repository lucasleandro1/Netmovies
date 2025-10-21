class CategoriesController < ApplicationController
  def index
    @categories = Category.ordered_by_name
  end

  def show
    @category = Category.find(params[:id])
    @movies = @category.movies
                       .includes(:user)
                       .ordered_by_newest
                       .page(params[:page])
                       .per(6)
  end
end

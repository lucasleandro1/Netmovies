class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show, :search ]
  before_action :set_movie, only: [ :show, :edit, :update, :destroy ]
  before_action :check_movie_owner, only: [ :edit, :update, :destroy ]

  def index
    @movies = MovieManager::Searcher.call(params)
    @categories = Category.ordered_by_name
    @q = params[:q]
  end

  def show
    @comment = Comment.new
    @comments = @movie.comments.includes(:user).ordered_by_newest
  end

  def new
    @movie = current_user.movies.build
    @categories = Category.ordered_by_name
    @tags = Tag.ordered_by_name
  end

  def create
    result = MovieManager::Creator.call(current_user, movie_params, params[:movie][:ai_poster_url])
    if result[:success]
      redirect_to result[:resource], notice: result[:message] || t("movies.created_successfully")
    else
      @movie = current_user.movies.build(movie_params)
      @categories = Category.ordered_by_name
      @tags = Tag.ordered_by_name
      flash.now[:alert] = result[:error_message]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.ordered_by_name
    @tags = Tag.ordered_by_name
  end

  def update
    result = MovieManager::Updater.call(current_user, @movie, movie_params)
    if result[:success]
      redirect_to @movie, notice: result[:message] || t("movies.updated_successfully")
    else
      @categories = Category.ordered_by_name
      @tags = Tag.ordered_by_name
      flash.now[:alert] = result[:error_message]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = MovieManager::Destroyer.call(current_user, @movie)
    if result[:success]
      redirect_to movies_path, notice: result[:message] || t("movies.deleted_successfully")
    else
      redirect_to movies_path, alert: result[:error_message]
    end
  end

  def search
    @q = params[:q]
    @movies = MovieManager::Searcher.call(params)
    @categories = Category.ordered_by_name
    render :index
  end

  def fetch_ai_data
    result = MovieManager::AiCreator.fetch_ai_data(params[:title])
    render json: result
  end

  def create_from_ai
    result = MovieManager::AiCreator.call(current_user, params[:title])
    render json: result
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def check_movie_owner
    unless @movie.user == current_user
      redirect_to movies_path, alert: t("movies.not_authorized")
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :duration, :director, :poster,
                                  category_ids: [], tag_ids: [])
  end

  # Filtros extraídos para MovieManager::Filterer
end

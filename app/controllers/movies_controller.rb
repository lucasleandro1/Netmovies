class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show, :search ]
  before_action :set_movie, only: [ :show, :edit, :update, :destroy ]
  before_action :check_movie_owner, only: [ :edit, :update, :destroy ]

  def index
    @movies = Movie.includes(:user, :categories)
                   .ordered_by_newest
                   .page(params[:page])
                   .per(8)
    @movies = apply_filters(@movies)

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
    @movie = current_user.movies.build(movie_params)

    if @movie.save
      if params[:movie][:poster].blank? && params[:movie][:ai_poster_url].present?
        ai_service = MovieAiService.new
        poster_url = params[:movie][:ai_poster_url]
        poster_attached = ai_service.download_and_attach_poster(@movie, poster_url)
        @movie.reload if poster_attached
      end
      redirect_to @movie, notice: t("movies.created_successfully")
    else
      @categories = Category.ordered_by_name
      @tags = Tag.ordered_by_name
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.ordered_by_name
    @tags = Tag.ordered_by_name
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: t("movies.updated_successfully")
    else
      @categories = Category.ordered_by_name
      @tags = Tag.ordered_by_name
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, notice: t("movies.deleted_successfully")
  end

  def search
    @q = params[:q]
    @movies = Movie.includes(:user, :categories)

    if @q.present?
      @movies = @movies.search_by_title(@q)
                       .or(Movie.by_director(@q))
    end

    @movies = apply_filters(@movies)
    @movies = @movies.ordered_by_newest.page(params[:page]).per(8)

    @categories = Category.ordered_by_name
    render :index
  end

  def fetch_ai_data
    title = params[:title]

    if title.blank?
      render json: { success: false, error: "Título é obrigatório" }
      return
    end

  ai_service = MovieAiService.new
  result = ai_service.fetch_movie_data(title)
  render json: result
  end

  def create_from_ai
    title = params[:title]

    return render json: { success: false, error: "Título é obrigatório" } if title.blank?

    ai_service = MovieAiService.new
    result = ai_service.fetch_movie_data(title)

    unless result[:success]
      return render json: result
    end

    movie_data = result[:data]

    movie = current_user.movies.build(
      title: movie_data["title"],
      synopsis: movie_data["synopsis"],
      year: movie_data["year"],
      duration: movie_data["duration"],
      director: movie_data["director"]
    )

    if movie.save
      Array(movie_data["categories"]).each do |category_name|
        category = Category.find_or_create_by(name: category_name)
        movie.categories << category unless movie.categories.include?(category)
      end

      Array(movie_data["tags"]).each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        movie.tags << tag unless movie.tags.include?(tag)
      end

      poster_url = movie_data["poster_url"]

      if poster_url.blank? || poster_url.include?("not found")
        poster_url = ai_service.fetch_poster_from_tmdb(movie.title)
      end

      poster_attached = false
      if poster_url.present?
        poster_attached = ai_service.download_and_attach_poster(movie, poster_url)

        if poster_attached
          movie.reload
          Rails.logger.info("Poster anexado com sucesso para o filme '#{movie.title}'")
        else
          Rails.logger.error("Falha ao anexar poster para o filme '#{movie.title}'")
        end
      else
        Rails.logger.warn("Nenhum poster encontrado para o filme '#{movie.title}'")
      end

      render json: {
        success: true,
        movie_id: movie.id,
        poster_attached: poster_attached,
        message: "Filme criado com sucesso#{poster_attached ? ' e pôster anexado' : ''}!"
      }
    else
      render json: { success: false, error: movie.errors.full_messages.join(", ") }
    end
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

  def apply_filters(movies)
    movies = movies.by_year(params[:year]) if params[:year].present?
    movies = movies.by_director(params[:director]) if params[:director].present?
    movies = movies.by_category(params[:category_id]) if params[:category_id].present?
    movies
  end
end

module MovieManager
  class Searcher
    def self.call(params)
      movies = Movie.includes(:user, :categories)
      if params[:q].present?
        movies = movies.search_by_title(params[:q]).or(Movie.by_director(params[:q]))
      end
      movies = Filterer.call(movies, params)
      movies.ordered_by_newest.page(params[:page]).per(8)
    end
  end
end

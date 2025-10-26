module MovieManager
  class Filterer
    def self.call(movies, params)
      movies = movies.by_year(params[:year]) if params[:year].present?
      movies = movies.by_director(params[:director]) if params[:director].present?
      movies = movies.by_category(params[:category_id]) if params[:category_id].present?
      movies
    end
  end
end

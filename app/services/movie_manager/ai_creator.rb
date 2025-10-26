module MovieManager
  class AiCreator
    def self.fetch_ai_data(title)
      return { success: false, error: "Título é obrigatório" } if title.blank?
      ai_service = MovieAiService.new
      ai_service.fetch_movie_data(title)
    end

    def self.call(user, title)
      return { success: false, error: "Título é obrigatório" } if title.blank?
      ai_service = MovieAiService.new
      result = ai_service.fetch_movie_data(title)
      return result unless result[:success]
      movie_data = result[:data]
      movie = user.movies.build(
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
          movie.reload if poster_attached
        end
        {
          success: true,
          movie_id: movie.id,
          poster_attached: poster_attached,
          message: "Filme criado com sucesso#{poster_attached ? ' e pôster anexado' : ''}!"
        }
      else
        { success: false, error: movie.errors.full_messages.join(", ") }
      end
    rescue StandardError => error
      { success: false, error: error.message }
    end
  end
end

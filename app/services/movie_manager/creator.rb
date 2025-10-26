module MovieManager
  class Creator
    attr_reader :user, :movie_params, :ai_poster_url

    def initialize(user, movie_params, ai_poster_url = nil)
      @user = user
      @movie_params = movie_params
      @ai_poster_url = ai_poster_url
    end

    def self.call(user, movie_params, ai_poster_url = nil)
      new(user, movie_params, ai_poster_url).call
    end

    def call
      movie = @user.movies.build(@movie_params)
      if movie.save
        attach_ai_poster(movie)
        response(movie)
      else
        response_error(movie.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def attach_ai_poster(movie)
      return unless @ai_poster_url.present? && movie.poster.blank?
      ai_service = MovieAiService.new
      poster_attached = ai_service.download_and_attach_poster(movie, @ai_poster_url)
      movie.reload if poster_attached
    end

    def response(data)
      { success: true, message: "Filme criado com sucesso.", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

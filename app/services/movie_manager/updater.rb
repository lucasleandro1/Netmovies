module MovieManager
  class Updater
    attr_reader :user, :movie, :movie_params

    def initialize(user, movie, movie_params)
  @user = user
  @movie = movie
  @movie_params = movie_params.dup
  @ai_poster_url = @movie_params.delete(:ai_poster_url)
    end

    def self.call(user, movie, movie_params)
      new(user, movie, movie_params).call
    end

    def call
      if @movie.user != @user
        response_error("Você não tem permissão para editar este filme.")
      elsif @movie.update(@movie_params)
        attach_ai_poster_if_needed
        response(@movie)
      else
        response_error(@movie.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def attach_ai_poster_if_needed
  return unless @ai_poster_url.present? && @ai_poster_url.start_with?("http") && !@movie.poster.attached?
  MovieManager::PosterAttacher.call(@movie, @ai_poster_url)
    end

    def response(data)
      { success: true, message: "Filme atualizado com sucesso.", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

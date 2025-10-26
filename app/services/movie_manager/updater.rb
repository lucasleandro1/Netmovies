module MovieManager
  class Updater
    attr_reader :user, :movie, :movie_params

    def initialize(user, movie, movie_params)
      @user = user
      @movie = movie
      @movie_params = movie_params
    end

    def self.call(user, movie, movie_params)
      new(user, movie, movie_params).call
    end

    def call
      if @movie.user != @user
        response_error("Você não tem permissão para editar este filme.")
      elsif @movie.update(@movie_params)
        response(@movie)
      else
        response_error(@movie.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "Filme atualizado com sucesso.", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

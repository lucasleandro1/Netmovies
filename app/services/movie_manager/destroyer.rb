module MovieManager
  class Destroyer
    attr_reader :user, :movie

    def initialize(user, movie)
      @user = user
      @movie = movie
    end

    def self.call(user, movie)
      new(user, movie).call
    end

    def call
      if @movie.user != @user
        response_error("Você não tem permissão para excluir este filme.")
      elsif @movie.destroy
        response(nil)
      else
        response_error(@movie.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(_data)
      { success: true, message: "Filme excluído com sucesso." }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

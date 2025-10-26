module CommentManager
  class Destroyer
    attr_reader :user, :movie, :comment

    def initialize(user, movie, comment)
      @user = user
      @movie = movie
      @comment = comment
    end

    def self.call(user, movie, comment)
      new(user, movie, comment).call
    end

    def call
      unless can_delete_comment?
        return response_error("Você não tem permissão para excluir este comentário.")
      end
      if @comment.destroy
        response(nil)
      else
        response_error(@comment.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def can_delete_comment?
      return false unless @user
      @comment.user == @user || @movie.user == @user
    end

    def response(_data)
      { success: true, message: "Comentário excluído com sucesso." }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

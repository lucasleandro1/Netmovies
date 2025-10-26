module CommentManager
  class Creator
    attr_reader :user, :movie, :comment_params

    def initialize(user, movie, comment_params)
      @user = user
      @movie = movie
      @comment_params = comment_params
    end

    def self.call(user, movie, comment_params)
      new(user, movie, comment_params).call
    end

    def call
      comment = @movie.comments.build(@comment_params)
      comment.user = @user if @user
      if comment.save
        response(comment)
      else
        response_error(comment.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "Comentário criado com sucesso.", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

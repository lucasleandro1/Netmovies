module MovieImportManager
  class Creator
    attr_reader :user, :import_params

    def initialize(user, import_params)
      @user = user
      @import_params = import_params
    end

    def self.call(user, import_params)
      new(user, import_params).call
    end

    def call
      movie_import = @user.movie_imports.build(
        status: "pending",
        error_count: 0,
        processed_count: 0,
        file_name: @import_params[:file_name].presence || "Importação #{Time.current.to_i}"
      )

      movie_import.csv_file.attach(@import_params[:csv_file])

      if movie_import.save
        response(movie_import)
      else
        response_error(movie_import.errors.full_messages.join(", "))
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "Importação criada com sucesso.", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end
  end
end

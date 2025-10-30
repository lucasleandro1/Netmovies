require "csv"
require "sidekiq/job"

class MovieImportJob
  include Sidekiq::Job

  def perform(movie_import_id)
    movie_import = MovieImport.find(movie_import_id)

    begin
      movie_import.update!(status: "processing", started_at: Time.current)

      csv_content = movie_import.csv_file.download
      processed_count = 0
      error_count = 0
      errors = []

      CSV.parse(csv_content, headers: true, col_sep: ",") do |row|
        line_number = $. # ou use uma variável contador se preferir

        begin
          movie = Movie.create!(
            title: row["title"],
            synopsis: row["synopsis"].presence || "Sinopse não informada",
            year: row["year"].to_i.nonzero? || Date.current.year,
            duration: row["duration"].to_i.nonzero? || 120,
            director: row["director"].presence || "Diretor não informado",
            user: movie_import.user
          )

          if row["categories"].present?
            row["categories"].split("|").map(&:strip).each do |category_name|
              category = Category.find_or_create_by!(name: category_name)
              movie.categories << category
            end
          end

          if row["tags"].present?
            row["tags"].split("|").map(&:strip).each do |tag_name|
              tag = Tag.find_or_create_by!(name: tag_name)
              movie.tags << tag
            end
          end

          processed_count += 1
        rescue => e
          error_count += 1
          errors << "Linha #{line_number}: #{e.message}"
        end
      end

      movie_import.update!(
        status: "completed",
        processed_count: processed_count,
        error_count: error_count,
        error_messages: errors.join("\n"),
        completed_at: Time.current
      )

      MovieImportMailer.import_completed(movie_import).deliver_now
    rescue => e
      movie_import.update!(
        status: "failed",
        error_messages: e.message,
        completed_at: Time.current
      )

      MovieImportMailer.import_failed(movie_import).deliver_now
    end
  end
end

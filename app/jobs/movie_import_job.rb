require "csv"
require "sidekiq/job"

class MovieImportJob
  include Sidekiq::Job

  def perform(movie_import_id)
    movie_import = MovieImport.find(movie_import_id)

    begin
      movie_import.update!(status: "processing", started_at: Time.current)

      csv_file = movie_import.csv_file.download
      processed_count = 0
      error_count = 0
      errors = []

      CSV.parse(csv_file, headers: true, col_sep: ",") do |row|
        begin
          movie = Movie.create!(
            title: row["title"],
            synopsis: row["synopsis"] || "Sinopse não informada",
            year: row["year"]&.to_i || Date.current.year,
            duration: row["duration"]&.to_i || 120,
            director: row["director"] || "Diretor não informado",
            user: movie_import.user
          )

          # Associate categories if provided
          if row["categories"].present?
            category_names = row["categories"].split(",").map(&:strip)
            category_names.each do |category_name|
              category = Category.find_or_create_by(name: category_name)
              movie.categories << category unless movie.categories.include?(category)
            end
          end

          # Associate tags if provided
          if row["tags"].present?
            tag_names = row["tags"].split(",").map(&:strip)
            tag_names.each do |tag_name|
              tag = Tag.find_or_create_by(name: tag_name)
              movie.tags << tag unless movie.tags.include?(tag)
            end
          end

          processed_count += 1
        rescue => e
          error_count += 1
          errors << "Linha #{$.}: #{e.message}"
        end
      end

      movie_import.update!(
        status: "completed",
        processed_count: processed_count,
        error_count: error_count,
        error_messages: errors.join("\n"),
        completed_at: Time.current
      )

      # Send notification email
      MovieImportMailer.import_completed(movie_import).deliver_now

    rescue => e
      movie_import.update!(
        status: "failed",
        error_messages: e.message,
        completed_at: Time.current
      )

      # Send error notification email
      MovieImportMailer.import_failed(movie_import).deliver_now
    end
  end
end

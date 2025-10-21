require "stringio"

class MovieAiService
  include HTTParty
  base_uri "https://api.openai.com/v1"

  def initialize
    @api_key = ENV["OPENAI_API_KEY"] || Rails.application.credentials.openai_api_key
  end

  def fetch_movie_data(title)
    return failure_response("API key não configurada") unless @api_key

    begin
      response = self.class.post("/chat/completions",
        headers: {
          "Authorization" => "Bearer #{@api_key}",
          "Content-Type" => "application/json"
        },
        body: {
          model: "gpt-3.5-turbo",
          messages: [
            {
              role: "system",
              content: "Você é um especialista em cinema. Retorne APENAS um JSON válido com as informações do filme solicitado. Formato: {\"title\":\"Título\",\"synopsis\":\"Sinopse detalhada\",\"year\":ano,\"duration\":minutos,\"director\":\"Diretor\",\"categories\":[\"Categoria1\",\"Categoria2\"],\"tags\":[\"tag1\",\"tag2\"],\"poster_url\":\"URL_da_imagem_do_poster\"}"
            },
            {
              role: "user",
              content: "Busque informações completas sobre o filme: #{title}"
            }
          ],
          max_tokens: 500,
          temperature: 0.3
        }.to_json
      )

      if response.success?
        content = response.dig("choices", 0, "message", "content")
        movie_data = JSON.parse(content)

        success_response(movie_data)
      else
        failure_response("Erro na API: #{response['error']['message']}")
      end

    rescue JSON::ParserError
      failure_response("Erro ao interpretar resposta da IA")
    rescue => e
      failure_response("Erro de conexão: #{e.message}")
    end
  end

  # Fallback usando OMDB API (gratuita)
  def fetch_movie_data_omdb(title)
    omdb_api_key = ENV["OMDB_API_KEY"] || Rails.application.credentials.omdb_api_key
    return failure_response("OMDB API key não configurada") unless omdb_api_key

    begin
      response = HTTParty.get("http://www.omdbapi.com/", {
        query: {
          t: title,
          apikey: omdb_api_key,
          plot: "full"
        }
      })

      if response.success? && response["Response"] == "True"
        movie_data = {
          title: response["Title"],
          synopsis: response["Plot"],
          year: response["Year"].to_i,
          duration: parse_runtime(response["Runtime"]),
          director: response["Director"],
          categories: parse_genre(response["Genre"]),
          tags: generate_tags(response),
          poster_url: response["Poster"]
        }

        success_response(movie_data)
      else
        failure_response("Filme não encontrado na base de dados")
      end

    rescue => e
      failure_response("Erro de conexão com OMDB: #{e.message}")
    end
  end

  # Baixa e anexa o pôster do filme
  def download_and_attach_poster(movie, poster_url)
    return false unless poster_url.present? && poster_url != "N/A"

    begin
      response = HTTParty.get(poster_url)

      if response.success?
        filename = "#{movie.title.parameterize}_poster.jpg"

        movie.poster.attach(
          io: StringIO.new(response.body),
          filename: filename,
          content_type: "image/jpeg"
        )

        true
      else
        false
      end
    rescue => e
      Rails.logger.error "Erro ao baixar pôster: #{e.message}"
      false
    end
  end

  private

  def success_response(data)
    { success: true, data: data }
  end

  def failure_response(message)
    { success: false, error: message }
  end

  def parse_runtime(runtime)
    return 120 unless runtime
    runtime.scan(/\d+/).first.to_i || 120
  end

  def parse_genre(genre)
    return [ "Drama" ] unless genre
    genre.split(", ").map(&:strip)
  end

  def generate_tags(data)
    tags = []
    tags << "oscar" if data["Awards"]&.include?("Oscar")
    tags << "imdb-top" if data["imdbRating"].to_f > 8.0
    tags << "recent" if data["Year"].to_i > 2020
    tags << "classic" if data["Year"].to_i < 1980
    tags.presence || [ "filme" ]
  end
end

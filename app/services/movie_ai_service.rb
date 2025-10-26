require "stringio"
require "net/http"
require "uri"
require "httparty"

class MovieAiService
  GEMINI_BASE_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent"

  def initialize
    @api_key = "AIzaSyAwkv0fhB9LCo1GyzVngQE2rJumIxxDNjE" #
    @tmdb_api_key = "e7a045b11f740d5c9fde1d599c4a660e"
  end

  def fetch_movie_data(title)
    return failure_response("API key da Gemini não configurada") unless @api_key.present?

    prompt = <<~PROMPT
      Você é um especialista em cinema. Responda **exclusivamente** com um JSON válido (sem comentários ou texto extra).
      O formato exato deve ser:
      {
        "title": "Título do filme",
        "synopsis": "Sinopse detalhada e envolvente",
        "year": 2010,
        "duration": 148,
        "director": "Nome do diretor",
        "categories": ["Ação", "Ficção científica"],
        "tags": ["mind-bending", "sci-fi", "thriller"]
      }

      Filme: #{title}
    PROMPT

    uri = URI("#{GEMINI_BASE_URL}?key=#{@api_key}")
    headers = { "Content-Type" => "application/json" }
    body = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ]
    }.to_json

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = body
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        json = JSON.parse(response.body)
        content = json.dig("candidates", 0, "content", "parts", 0, "text")
        cleaned_json = content[/\{.*\}/m]
        movie_data = JSON.parse(cleaned_json) rescue nil

        return failure_response("A IA não retornou um JSON válido") unless movie_data

        poster_url = fetch_poster_from_tmdb(title)
        movie_data["poster_url"] = poster_url if poster_url.present?

        success_response(movie_data)
      else
        failure_response("Erro na API Gemini: #{response.body}")
      end
    rescue JSON::ParserError
      failure_response("Erro ao interpretar resposta da IA Gemini")
    rescue => e
      failure_response("Erro de conexão: #{e.message}")
    end
  end

  def download_and_attach_poster(movie, poster_url)
    return false unless poster_url.present? && poster_url.start_with?("http")

    begin
      response = HTTParty.get(poster_url, follow_redirects: true)
      return false unless response.success?

      content_type = response.headers["content-type"] || "image/jpeg"
      filename = "#{movie.title.parameterize}_poster.jpg"

      movie.poster.attach(
        io: StringIO.new(response.body),
        filename: filename,
        content_type: content_type
      )
      true
    rescue => e
      Rails.logger.error("Erro ao baixar pôster: #{e.message}")
      false
    end
  end

  private

  def fetch_poster_from_tmdb(title)
    return nil unless @tmdb_api_key.present?

    encoded_title = URI.encode_www_form_component(title)
    search_url = "https://api.themoviedb.org/3/search/movie?api_key=#{@tmdb_api_key}&query=#{encoded_title}"

    response = HTTParty.get(search_url)
    return nil unless response.success?

    result = response.parsed_response["results"]&.first
    return nil unless result && result["poster_path"]

    "https://image.tmdb.org/t/p/w500#{result['poster_path']}"
  rescue => e
    Rails.logger.error("Erro ao buscar poster no TMDb: #{e.message}")
    nil
  end


  def success_response(data)
    { success: true, data: data }
  end

  def failure_response(message)
    { success: false, error: message }
  end
end

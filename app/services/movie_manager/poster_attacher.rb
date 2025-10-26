module MovieManager
  class PosterAttacher
    def self.call(movie, poster_url)
      return false if poster_url.blank? || movie.poster.present?
      ai_service = MovieAiService.new
      poster_attached = ai_service.download_and_attach_poster(movie, poster_url)
      movie.reload if poster_attached
      poster_attached
    end
  end
end

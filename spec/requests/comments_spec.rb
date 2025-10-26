require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:movie) { create(:movie) }
  let!(:comment) { create(:comment, movie: movie) }

  describe "POST /movies/:movie_id/comments" do
    it "creates a comment and redirects" do
      post "/movies/#{movie.id}/comments", params: { comment: { content: "Test comment", commenter_name: "Test" } }
      expect(response).to have_http_status(:found)
      expect(response.headers["Location"]).to include(movie_path(movie))
    end
  end

  describe "DELETE /movies/:movie_id/comments/:id" do
    it "deletes a comment and redirects" do
      delete "/movies/#{movie.id}/comments/#{comment.id}"
      expect(response).to have_http_status(:found)
      expect(response.headers["Location"]).to include(movie_path(movie))
    end
  end
end

require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let(:user) { create(:user) }
  let!(:movie) { create(:movie, user: user) }

  describe "GET /movies" do
    it "returns http success" do
      get "/movies"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /movies/:id" do
    it "returns http success" do
      get "/movies/#{movie.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /movies/new" do
    it "returns http success" do
      sign_in user
      get "/movies/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /movies" do
    it "creates a movie and redirects" do
      sign_in user
      post "/movies", params: { movie: { title: "Test", synopsis: "Test synopsis for movie", year: 2020, duration: 120, director: "Director", category_ids: [], tag_ids: [] } }
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /movies/:id/edit" do
    it "returns http success" do
      sign_in user
      get "/movies/#{movie.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /movies/:id" do
    it "updates a movie and redirects" do
      sign_in user
      patch "/movies/#{movie.id}", params: { movie: { title: "Updated Title" } }
      expect(response).to have_http_status(:found)
    end
  end

  describe "DELETE /movies/:id" do
    it "deletes a movie and redirects" do
      sign_in user
      delete "/movies/#{movie.id}"
      expect(response).to have_http_status(:found)
    end
  end
end

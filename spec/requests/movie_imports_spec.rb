require 'rails_helper'

RSpec.describe "MovieImports", type: :request do
  let(:user) { create(:user) }
  let!(:movie_import) { create(:movie_import, user: user) }

  before do
    sign_in user
  end

  describe "GET /movie_imports" do
    it "returns http success" do
      get "/movie_imports"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /movie_imports/new" do
    it "returns http success" do
      get "/movie_imports/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /movie_imports" do
    it "creates a movie import and redirects" do
      post "/movie_imports", params: { movie_import: { file_name: "import.csv", csv_file: fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.csv'), 'text/csv') } }
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /movie_imports/:id" do
    it "returns http success" do
      get "/movie_imports/#{movie_import.id}"
      expect(response).to have_http_status(:success)
    end
  end
end

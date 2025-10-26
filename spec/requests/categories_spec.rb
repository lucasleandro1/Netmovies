require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/categories"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let!(:category) { create(:category) }
    it "returns http success" do
      get "/categories/#{category.id}"
      expect(response).to have_http_status(:success)
    end
  end
end

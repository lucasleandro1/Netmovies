class SeedsController < ApplicationController
  def run
    # só execute uma vez ou com algum token
    load Rails.root.join("db/seeds.rb")
    render plain: "Seed executado!"
  end
end

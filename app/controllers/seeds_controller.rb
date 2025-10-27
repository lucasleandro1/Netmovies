class SeedsController < ApplicationController
  def setup_images
    system("bin/rails importmap:install")
    system("bin/rails importmap:pin stimulus")
    system("bin/rails importmap:pin_all_from app/javascript/controllers")
    system("bundle exec rails assets:precompile")
    system("bundle exec rails importmap:install")
    render plain: "Comandos executados!"
  end

  def run
    # só execute uma vez ou com algum token
    system("rails db:drop db:create db:migrate")
    load Rails.root.join("db/seeds.rb")
    render plain: "Seed executado!"
  end
end

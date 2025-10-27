class SidekiqControlController < ApplicationController
  def start
    system("sidekiq -C config/sidekiq.yaml > /dev/null 2>&1 &")
    render plain: "Sidekiq iniciado"
  end
end

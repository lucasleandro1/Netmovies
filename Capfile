# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load Capistrano plugins
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "capistrano/puma" # ou "capistrano/passenger" se usar Passenger
install_plugin Capistrano::Puma  # só se estiver usando Puma

# Load custom tasks from `lib/capistrano/tasks` if any
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

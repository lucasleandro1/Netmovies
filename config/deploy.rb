lock "~> 3.19.0"

set :application, "meu_app"
set :repo_url, "git@github.com:lucasleandro1/Netmovies.git"

# Caminho onde o app será instalado no servidor
set :deploy_to, "/var/www/meu_app"

# Configuração do Ruby
set :rbenv_type, :user
set :rbenv_ruby, "3.2.2"

# Manter links persistentes
append :linked_files, "config/master.key", ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

set :keep_releases, 5

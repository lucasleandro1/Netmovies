server "seu.ip.do.servidor", user: "deploy", roles: %w[app db web]

set :rails_env, "production"
set :branch, "main"

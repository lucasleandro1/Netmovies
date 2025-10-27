FROM ruby:3.4.4-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config \
    nodejs npm libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Copia Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instala gems dentro do projeto
RUN bundle config set path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3

# Copia aplicação
COPY . .

# Cria usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd --uid 1000 --gid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails .

USER rails
EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM ruby:3.4.4-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config \
    nodejs npm

# Copia Gemfiles e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia aplicação
COPY . .

# Cria usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails db log storage tmp

USER rails
EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

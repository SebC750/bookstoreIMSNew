# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Base OS dependencies (minimal)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# --------------------------
# Build stage
# --------------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libvips \
    libpq-dev \
    libsqlite3-dev \
    pkg-config \
    curl \
    git \
    nodejs \
    sqlite3 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'development test' && \
    bundle install && \
    bundle binstubs bootsnap --force && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    ./bin/bootsnap precompile --gemfile



COPY . .

# Precompile Rails assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# --------------------------
# Runtime stage
# --------------------------
FROM base AS runtime

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]

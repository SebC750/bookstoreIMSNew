# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"

# --------------------------
# Build stage
# --------------------------
FROM base AS build

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libyaml-dev \
      libgmp-dev \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      libffi-dev \
      ruby-dev \
      libsqlite3-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_JOBS=1
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app code
COPY app app
COPY config config
COPY db db
COPY public ./public
COPY lib lib
COPY Rakefile .
COPY .ruby-version .

RUN bundle exec bootsnap precompile app/ lib/
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get update -qq \
 && apt-get install --no-install-recommends -y nodejs yarn \
 && rm -rf /var/lib/apt/lists/*

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile


# --------------------------
# Runtime stage
# --------------------------
# --- FINAL IMAGE ---
    FROM base AS runtime

    WORKDIR /rails
    
    # Copy built app and gems from build stage
    COPY --from=build /usr/local/bundle /usr/local/bundle
    COPY --from=build /rails/. /rails/
    # Create non-root user and ensure dirs exist
    RUN mkdir -p log storage tmp && \
        groupadd --system --gid 1000 rails && \
        useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
        chown -R rails:rails db log storage tmp
    
    USER 1000:1000
    
    ENTRYPOINT ["/rails/bin/docker-entrypoint"]
    EXPOSE 80
    CMD ["./bin/thrust", "./bin/rails", "server"]

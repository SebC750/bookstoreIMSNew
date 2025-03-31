# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install system dependencies and Litestream
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 \
      libyaml-dev \
      tzdata \
      build-essential \
      git \
      pkg-config && \
    curl -fsSL https://github.com/benbjohnson/litestream/releases/download/v0.3.11/litestream-v0.3.11-linux-amd64.tar.gz \
      -o /tmp/litestream.tar.gz && \
    mkdir -p /tmp/litestream && \
    tar -xzf /tmp/litestream.tar.gz -C /tmp/litestream && \
    mv /tmp/litestream/litestream /usr/local/bin/litestream && \
    chmod +x /usr/local/bin/litestream && \
    rm -rf /tmp/litestream*

# Set environment variables
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# ----- Build stage -----
FROM base AS build

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

# Copy application code
COPY . .

# Precompile assets and bootsnap
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE=dummy ./bin/rails assets:precompile

# ----- Final runtime image -----
FROM base AS runtime

# Copy built app and gems
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Create non-root user for app
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails

# Entrypoint sets up DB and starts app
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port for Fly.io
EXPOSE 8080

# Start the Rails app with Litestream
CMD ["litestream", "replicate", "--exec", "bin/rails server -b 0.0.0.0 -p 8080"]

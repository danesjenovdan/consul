FROM ruby:2.6.7 as build

ENV DEBIAN_FRONTEND noninteractive

# Install essential Linux packages
RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev postgresql-client nodejs imagemagick sudo libxss1 libappindicator1 libindicator7 unzip memcached cmake pkg-config shared-mime-info

# Files created inside the container repect the ownership
RUN adduser --shell /bin/bash --disabled-password --gecos "" consul \
  && adduser consul sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN echo 'Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bundle/bin"' > /etc/sudoers.d/secure_path
RUN chmod 0440 /etc/sudoers.d/secure_path

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

# Define where our application will live inside the image
ENV RAILS_ROOT /var/www/consul

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

COPY Gemfile_custom Gemfile_custom

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby environment
RUN bundle install --full-index

# Install Chromium for E2E integration tests
RUN apt-get update -qq && apt-get install -y chromium

# Copy the Rails application into place
COPY . .

# precompile assets for production
# ENV RAILS_ENV development
# RUN ./bin/rake assets:precompile

FROM nginx:alpine

COPY --from=build /var/www/consul/public /usr/share/nginx/html
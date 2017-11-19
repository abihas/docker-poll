# Docker file for poll.lab.io

# Pull base image
# https://hub.docker.com/_/ruby/
FROM ruby:2.1-alpine
MAINTAINER Michael Nieuwenweg <info@michaelnieuwenweg.nl>

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base postgresql-dev libpq nodejs postgresql-client 
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler


# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES --no-cache && \
    apk add $RUBY_PACKAGES  --no-cache 
    # rm -rf /var/cache/apk/*

RUN mkdir /usr/app
WORKDIR /usr/app

COPY poll/. /usr/app
RUN bundle install

COPY .env /usr/app
COPY wait-for-postgres.sh /usr/app 
COPY init.sh /usr/app

# CMD ["tail", "-f", "/usr/app/Gemfile"]
# CMD ["rails", "server"]
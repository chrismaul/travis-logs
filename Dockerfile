FROM ruby:2.5.3-alpine

LABEL maintainer Travis CI GmbH <support+travis-app-docker-images@travis-ci.com>

RUN apk add --no-cache build-base postgresql-dev tzdata postgresql-client perl git bash \
  curl wget perl-app-cpanminus perl-namespace-autoclean perl-namespace-clean \
  perl-package-stash perl-params-util perl-data-optlist perl-sub-exporter \
  perl-perlio-utf8_strict perl-clone perl-dbi perl-datetime perl-dbd-pg

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile      /usr/src/app
COPY Gemfile.lock /usr/src/app

RUN bundle install --deployment

COPY . /usr/src/app

# Sqitch expects partman
# RUN /usr/src/app/script/install-partman

# Install sqitch so migrations work
RUN cpanm App::Sqitch -n

CMD /bin/bash

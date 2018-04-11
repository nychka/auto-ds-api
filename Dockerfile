FROM ruby:2.4.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
ENV BUNDLE_GEMFILE=/myapp/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle
RUN bundle install
COPY . /myapp
RUN rm  -f /myapp/.env

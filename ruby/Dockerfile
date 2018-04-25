FROM ruby:2.5.1-alpine3.7
ENV ORG=""
ENV TOKEN=""
WORKDIR work
COPY Gemfile ./
RUN bundle install
COPY *.rb ./

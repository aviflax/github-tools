FROM ruby:2.5.3-alpine3.8
ENV GITHUB_ORG=""
ENV GITHUB_TOKEN=""

# If you change this, make sure to keep this line in sync with the line
# near the top of features/support/env.rb that adds /work/src to $LOAD_PATH.
WORKDIR /work

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . ./

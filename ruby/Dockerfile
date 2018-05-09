FROM ruby:2.5.1-alpine3.7
ENV ORG=""
ENV TOKEN=""

# If you change this, make sure to keep this line in sync with the line
# near the top of features/support/env.rb that adds /work/src to $LOAD_PATH.
WORKDIR /work

COPY Gemfile ./
RUN bundle install
COPY . ./

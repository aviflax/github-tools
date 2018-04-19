FROM 'ruby:2.5.0-alpine3.7'
ENV ORG=""
ENV TOKEN=""
RUN gem install octokit:4.8.0 parallel:1.12.1 ruby-progressbar:1.9.0
WORKDIR work
COPY *.rb ./

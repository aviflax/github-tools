# frozen_string_literal: true

# Get the config from the environment and make it available.
module Config
  REQUIRED = [
    ['GITHUB_ORG',
     'The environment variable GITHUB_ORG must contain the GitHub “organization” name.'],
    ['GITHUB_TOKEN',
     'The environment variable GITHUB_TOKEN must contain the GitHub OAuth token.']
  ].freeze

  def self.validate!
    REQUIRED.each do |var, msg|
      val = ENV[var]
      abort msg unless val.is_a?(String) && !val.strip.empty?
    end
    nil
  end

  def self.[](name)
    ENV[name&.to_s&.upcase]
  end

  # Requires that #[:token] returns a valid GitHub OAuth token, so you should probably call
  # #validate! first.
  def self.make_client
    client = Octokit::Client.new access_token: self[:token]
    client.auto_paginate = true
    client
  end
end

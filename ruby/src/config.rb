# frozen_string_literal: true

# Get the config from the environment and make it available.
module Config
  REQUIRED = [
    ['GITHUB_ORG',
     'The environment variable GITHUB_ORG must contain the GitHub “organization” name.'],
    ['GITHUB_TOKEN',
     'The environment variable GITHUB_TOKEN must contain the GitHub Personal Access Token.']
  ].freeze

  def self.validate!
    REQUIRED.each do |var, msg|
      val = ENV[var]
      abort msg unless val.is_a?(String) && !val.strip.empty?
    end
    nil
  end

  # Allows key values passed to #[] and #fetch to be symbols and/or lowercase
  def self.fixup_key(key)
    key&.to_s&.upcase
  end

  def self.[](key)
    ENV[fixup_key key]
  end

  def self.fetch(key)
    ENV.fetch fixup_key(key)
  end

  # Requires that #[:token] returns a valid GitHub OAuth token, so you should probably call
  # #validate! first.
  def self.make_client
    client = Octokit::Client.new access_token: fetch(:github_token)
    client.auto_paginate = true
    client
  end
end

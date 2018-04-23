# frozen_string_literal: true

require 'octokit'
require_relative './config'

Config.validate!
client = Config.make_client
repos = client.org_repos Config[:org]
puts repos.map(&:name).sort

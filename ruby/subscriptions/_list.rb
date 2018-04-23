# frozen_string_literal: true

require 'octokit'
require_relative './config'

Config.validate!
client = Config.make_client

begin
  subs = client.subscriptions.select { |repo| repo.owner.login == Config[:org] }
  puts subs.map(&:name).sort.join("\n")
rescue Octokit::TooManyRequests
  pp client.rate_limit
end

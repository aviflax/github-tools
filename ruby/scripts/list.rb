# frozen_string_literal: true

require 'config'
require 'github_tools'
require 'octokit'

Config.validate!
client = Config.make_client

kind = ARGV[0]&.to_sym   # what kind of thing to list (repos or subs)
first_flag = ARGV[1]     # should be either nil, blank, or `--topic`
topic = ARGV[2]          # optional, applies only to repos, only if first_flag is --topic

kinds = {
  subs: -> { client.subscriptions.select { |repo| repo.owner.login == Config[:org] } },
  repos: -> { GitHubTools.org_repos topic, Config[:org], client }
}

if !kinds.keys.include?(kind) ||
   (!first_flag.nil? && !first_flag.empty? && first_flag != '--topic') ||
   (first_flag == '--topic' && (topic.nil? || topic.empty?))
  abort 'usage: list subs | list repos | list repos --topic <topic>'
end

repos = kinds[kind].call
puts repos.map(&:name).sort

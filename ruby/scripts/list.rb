# frozen_string_literal: true

require 'config'
require 'github_tools'

Config.validate!
client = Config.make_client
org = Config.fetch(:github_org).strip

kind = ARGV[0]         # Kind of thing to list. Must be 'repos' (for now)
first_flag = ARGV[1]   # Must be --all | --subscribed | --topic
topic = ARGV[2]        # Required if first_flag is --topic; otherwise should be nil/blank

usage = 'usage: list repos --all | list repos --subscribed | list repos --topic <topic>'

if kind != 'repos' || first_flag.nil? || !first_flag.start_with?('--') ||
   (first_flag == '--topic' && (topic.nil? || topic.empty?)) ||
   (first_flag != '--topic' && !(topic.nil? || topic.empty?))
  abort usage
end

repos = case first_flag
        when '--subscribed'
          client.subscriptions.select { |repo| repo.owner.login.strip.casecmp? org }
        when '--all', '--topic'
          GitHubTools.org_repos topic, org, client
        else
          abort usage
        end

puts repos.map(&:name).sort

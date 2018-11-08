# frozen_string_literal: true

require 'config'
require 'github_tools'

Config.validate!
client = Config.make_client
org = Config.fetch(:github_org).strip

kind = ARGV[0]         # Kind of thing to list. Must be 'repos' (for now)
first_flag = ARGV[1]   # Must be --all | --private | --subscribed | --topic
topic = ARGV[2]        # Required if first_flag is --topic; otherwise should be nil/blank

forks_note = 'note: --forks lists repos that were forked INTO the specified org'

usage = 'usage: list repos ' \
        "<one of: (--all | --private | --public | --subscribed | --forks | --topic <topic>)> \n" \
        " #{forks_note}"

criterion = first_flag&.[](2..-1)&.downcase&.to_sym

if kind != 'repos' || !first_flag&.start_with?('--') || criterion.nil? ||
   (criterion == :topic && (topic.nil? || topic.empty?)) ||
   (criterion == :topic && !(topic.nil? || topic.empty?))
  abort usage
end

warn forks_note if criterion == :forks

repos = case criterion
        when :subscribed
          GitHubTools.subscribed_repos org, client
        when :topic
          GitHubTools.org_repos org, client, topic: topic
        when :all, :private, :public, :forks
          GitHubTools.org_repos org, client, type: criterion.to_s
        else
          abort usage
        end

puts repos.map(&:name).sort

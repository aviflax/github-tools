# frozen_string_literal: true

require 'config'
require 'github_tools'
require 'octokit'

Config.validate!
client = Config.make_client

what = ARGV[0] # whether to list repos or subs
topic = ARGV[1] # optional, applies only to repos

repos = case what
        when 'repos' then GitHubTools.org_repos topic, Config[:org], client
        when 'subs' then client.subscriptions.select { |repo| repo.owner.login == Config[:org] }
        else abort 'First arg must be either \'repos\' or \'subs\''
        end

puts repos.map(&:name).sort

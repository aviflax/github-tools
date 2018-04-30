# frozen_string_literal: true

require 'config'
require 'github_tools'
require 'octokit'
require 'parallel'

THREADS = 6

Config.validate!
client = Config.make_client
org = Config[:org]

repo_names = STDIN.readlines chomp: true

if repo_names.empty?
  warn 'No repos, nothing to do.'
  exit 0
end

progress_label = "Subscribing to #{repo_names.length} repos"

Parallel.each(repo_names, in_threads: THREADS, progress: progress_label) do |repo_name|
  GitHubTools.handle_errs(client) do
    client.update_subscription "#{org}/#{repo_name}", subscribed: true
  end
end

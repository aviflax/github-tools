# frozen_string_literal: true

require 'config'
require 'github_tools'
require 'parallel'

THREADS = 6

Config.validate!
client = Config.make_client
org = Config.fetch :github_org

kind = ARGV[0]         # Kind of thing to alter. Must be 'repos' (for now)
first_flag = ARGV[1]   # Must be --disable (for now)
feature = ARGV[2]      # Must be forking (for now)

usage = 'usage: alter repos --disable forking'

abort usage if kind != 'repos' || first_flag != '--disable' || feature != 'forking'

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

# frozen_string_literal: true

require 'octokit'
require 'parallel'
require_relative './config'

THREADS = 6

Config.validate!

# TODO: PRINT AN ERROR ON TIMEOUT OR IF STDIN is closed or empty
repo_names = STDIN.readlines chomp: true
client = Config.make_client
org = Config[:org]

progress_label = "Unsubscribing from #{repo_names.length} repos"

Parallel.each(repo_names, in_threads: THREADS, progress: progress_label) do |repo_name|
  client.delete_subscription "#{org}/#{repo_name}"
rescue Octokit::TooManyRequests
  pp client.rate_limit
  raise
end

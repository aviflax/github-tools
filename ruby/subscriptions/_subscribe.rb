# frozen_string_literal: true

require 'octokit'
require 'parallel'
require_relative './config'

THREADS = 6

def oh_no(msg)
  puts msg
  exit false
end

def args
  topic = ARGV[0] || ''

  if topic.empty?
    oh_no 'The first arg must be either a topic or - to indicate to read a list of repos via STDIN.'
  end

  read_from_stdin = topic == '-'

  [topic, read_from_stdin]
end

def repos_from_stdin
  repo_names = STDIN.readlines chomp: true
  oh_no 'If the first arg is - you must supply a list of repos via STDIN.' if repo_names.empty?
  repo_names
end

def print_now(s)
  print s
  $stdout.flush
end

def get_repo_names(topic, org, client)
  print "Retrieving list of #{org} repos with topic #{topic} ... "

  result = client.search_repos "user:#{org} topic:#{topic}"

  puts "#{result.total_count} repos found\n\n"

  # TODO: possible bug in this function: I don’t know whether auto_paginate works for this method.
  # So if there’s more than 100 repos with the given topic this might return only the first 100.
  # This is an edge case so I’m OK with this for now.
  if result.total_count == 100
    puts "Warning! There may be additional matching repos that weren’t retrieved!\n\n"
  end

  result.items.map(&:name)
end

def subscribe(repo_names, org, client)
  progress_label = "Subscribing to #{repo_names.length} repos"

  Parallel.each(repo_names, in_threads: THREADS, progress: progress_label) do |repo_name|
    full_name = "#{org}/#{repo_name}"
    client.update_subscription full_name, subscribed: true
  rescue Octokit::TooManyRequests
    pp client.rate_limit
    raise
  end
end

def lets_do_this
  Config.validate!
  org = Config[:org]
  client = Config.make_client
  topic, read_from_stdin = args

  repo_names = read_from_stdin ? repos_from_stdin : get_repo_names(topic, org, client)

  if repo_names.empty?
    puts 'No repos, nothing to do.'
    exit true
  end

  subscribe repo_names, org, client
end

lets_do_this

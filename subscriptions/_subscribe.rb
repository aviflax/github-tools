# frozen_string_literal: true

require 'octokit'
require_relative './config'

Config.validate!

def oh_no(msg)
  puts msg
  exit false
end

topic = ARGV[0] || ''

if topic.empty?
  oh_no 'The first arg must be either a topic or - to indicate to read a list of repos via STDIN.'
end

read_from_stdin = topic == '-'
retrieve_via_topic = !read_from_stdin
repo_names_supplied = read_from_stdin ? STDIN.readlines(chomp: true) : []

if read_from_stdin && repo_names_supplied.empty?
  oh_no 'If the first arg is - you must supply a list of repos via STDIN.'
elsif !read_from_stdin && !repo_names_supplied.empty?
  oh_no 'If you wish to supply a list of repos via STDIN you must specify - as the first arg.'
end

client = Config.make_client
org = Config[:org]

def print_now(s)
  print s
  $stdout.flush
end

def get_repo_names(client, topic, org)
  print_now "Retrieving list of #{org} repos with topic #{topic} ... "
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

repo_names = retrieve_via_topic ? get_repo_names(client, topic, org) : repo_names_supplied

if repo_names.empty?
  puts 'No repos, nothing to do.'
  exit true
end

puts "Subscribing to #{repo_names.length} repos:\n\n"

repo_names.each do |repo_name|
  print_now "#{repo_name} ... "

  full_name = "#{org}/#{repo_name}"
  client.update_subscription full_name, subscribed: true

  print_now "👍\n"
end

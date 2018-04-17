# frozen_string_literal: true

require 'octokit'
require_relative './config'

Config.validate!

# TODO: PRINT AN ERROR ON TIMEOUT OR IF STDIN is closed or empty
repo_names = STDIN.readlines chomp: true

client = Octokit::Client.new access_token: Config[:token]
client.auto_paginate = true

org = Config[:org]

repo_names.each do |repo_name|
  print "#{repo_name} ... "
  $stdout.flush

  full_name = "#{org}/#{repo_name}"
  client.delete_subscription full_name

  puts '👍'
  $stdout.flush
end

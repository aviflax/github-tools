# frozen_string_literal: true

require 'octokit'
require_relative './config'

Config.validate!

client = Octokit::Client.new access_token: Config[:token]
client.auto_paginate = true

repos = client.subscriptions
              .select { |repo| repo.owner.login == Config[:org] }

repos.map(&:name)
     .sort
     .each { |name| puts name }

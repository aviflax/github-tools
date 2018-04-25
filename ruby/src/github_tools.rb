# frozen_string_literal: true

# Various functions for working with GitHub
module GitHubTools
  def self.warn_now(s)
    $stderr.print s
    $stderr.flush
  end

  # Writes to stderr only, not stdout, because stdout is only for results
  def self.org_repos_for_topic(topic, org, client)
    warn_now "Retrieving list of #{org} repos with topic #{topic} ... "

    result = client.search_repos "user:#{org} topic:#{topic}"

    warn_now "#{result.total_count} repos found\n"

    # TODO: possible bug in this function: I don’t know whether auto_paginate works for this method.
    # So if there’s more than 100 repos with the given topic this might return only the first 100.
    # This is an edge case so I’m OK with this for now.
    if result.total_count == 100
      warn "Warning! There may be additional matching repos that weren’t retrieved!\n"
    end

    result.items
  end

  def self.handle_errs
    yield
  rescue Octokit::TooManyRequests
    pp client.rate_limit
    raise
  end

  def self.org_repos(topic, org, client)
    handle_errs do
      if topic.nil? || topic.empty?
        client.org_repos org
      else
        org_repos_for_topic topic, org, client
      end
    end
  end
end

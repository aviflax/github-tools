# frozen_string_literal: true

require 'config'
require 'github_tools'

Config.validate!
client = Config.make_client
org = Config.fetch(:github_org).strip

kind = ARGV[0]         # Kind of thing to list. Must be 'repos' (for now)
first_flag = ARGV[1]   # See usage below
topic = ARGV[2]        # Required if first_flag is --topic; otherwise should be nil/blank

notes = {
  forks: 'lists repos that were forked INTO the specified org',
  # As far as I can tell, `sources` is not limited to repos that *have* forks (as I had hoped)
  sources: 'lists repos that are not forks'
}

usage = <<~HEREDOC
  usage: list repos
    and one of:
      --all
      --private
      --public
      --subscribed
      --forks             #{notes[:forks]}
      --forks-of <repo>   (use unqualified repo name; org context assumed)
      --sources           #{notes[:sources]}
      --topic <topic>
HEREDOC

# This is ridiculous -- we should probably be using OptionParser.
criterion = first_flag&.[](2..-1)&.downcase&.sub('-', '')&.to_sym

if kind != 'repos' || !first_flag&.start_with?('--') || criterion.nil? ||
   (criterion == :topic && (topic.nil? || topic.empty?)) ||
   (criterion != :topic && !(topic.nil? || topic.empty?))
  abort usage
end

warn "note: this option (--#{criterion}) #{notes[criterion]}" if notes.include? criterion

repos =
  case criterion
  when :subscribed
    GitHubTools.subscribed_repos org, client
  when :topic
    GitHubTools.org_repos org, client, topic: topic
  when :forksof
    raise NotImplementedError
  when :all, :private, :public, :forks, :sources
    GitHubTools.org_repos org, client, type: criterion.to_s
  else
    abort usage
  end

# When we print a repo that’s in the org specified by ENV['GITHUB_ORG] then we want to
# print the short unqualified name. When we print one that is not, we want to print the full
# qualified name.
def printable_name(repo, org)
  repo.owner.login == org ? repo.name : repo.full_name
end

puts repos.map { |repo| printable_name repo, org }
          .sort

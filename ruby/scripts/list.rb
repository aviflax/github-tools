# frozen_string_literal: true

require 'config'
require 'github_tools'

Config.validate!
client = Config.make_client
org = Config.fetch(:github_org).strip

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

# I tried OptionParser, I swear, but it doesn’t seem to support required arguments nor a case
# wherein at least one of a set of options is required.
kind, first_flag, arg_val = ARGV
criterion = first_flag&.[](2..-1)&.downcase&.sub('-', '')&.to_sym

case criterion
when :forksof then repo_name = arg_val
when :topic then topic = arg_val
end

if kind != 'repos' || !first_flag&.start_with?('--') || criterion.nil? ||
   (criterion == :topic && (topic.nil? || topic.empty?)) ||
   (criterion == :forksof && (repo_name.nil? || repo_name.empty?)) ||
   (!%i[topic forksof].include?(criterion) && !(arg_val.nil? || arg_val.empty?))
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
    raise NotImplementedError, "Cannot yet not list forks of #{repo_name}"
  when :all, :private, :public, :forks, :sources
    GitHubTools.org_repos org, client, type: criterion.to_s
  else
    abort usage
  end

puts repos.map { |repo| GitHubTools.printable_name repo, org }
          .sort

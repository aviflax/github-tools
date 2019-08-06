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
    and one mode:
      --all
      --private
      --public
      --subscribed
      --forks             #{notes[:forks]}
      --forks-of <repo>   (use unqualified repo name; org context assumed)
      --sources           #{notes[:sources]}
      --topic <topic>
      --no-owners

    and optionally one of:
      --format=<format>   (either 'names-only' or 'json-stream')
HEREDOC

def normalize(arg_val)
  arg_val.downcase&.sub('-', '_')&.to_sym
end

# I tried OptionParser, I swear, but it doesn’t seem to support required arguments nor a case
# wherein at least one of a set of options is required.
# TODO: Find an argument parsing library that’ll work for our needs and USE IT.
# repos --no-owners --format json-stream
# kind  first_flag  arg_val  format_arg
kind, mode_arg, arg_val, _format_arg = ARGV
mode = normalize(mode_arg&.[](2..-1))

case mode
when :forks_of then repo_name = arg_val
when :topic then topic = arg_val
end

# TODO: WTF
format = ARGV.join.include?('--format=json-stream') ? :json_stream : :names_only

if kind != 'repos' ||
   !mode_arg&.start_with?('--') ||
   mode.nil? ||
   (mode == :topic && topic&.empty?) ||
   (mode == :forks_of && topic&.empty?)
  # || TODO: FIX and RESTORE WTF # (!%i[topic forks_of].include?(mode) && !arg_val&.empty?)
  abort usage
end

warn "note: this option (--#{mode}) #{notes[mode]}" if notes.include? mode

repos =
  case mode
  when :subscribed
    GitHubTools.subscribed_repos org, client
  when :topic
    GitHubTools.org_repos org, client, topic: topic
  when :forks_of
    raise NotImplementedError, "Cannot yet not list forks of #{repo_name}"
  when :no_owners
    GitHubTools.org_repos(org, client)
               .reject { |repo| GitHubTools::Filters.codeowners? repo, client }
  when :all, :private, :public, :forks, :sources
    GitHubTools.org_repos org, client, type: mode.to_s
  else
    abort usage
  end

## TODO: move to a module
sorted_repo_names = lambda { |rs|
  rs.map { |repo| GitHubTools.printable_name repo, org }
    .sort_by(&:downcase)
}

## TODO: let’s move some of this logic into a module
case format
when :names_only
  puts sorted_repo_names.call(repos)
when :json_stream
  # WTF Refactor this shit!
  # TODO: this is only doing a shallow conversion to a hash; the output includes various values
  # like "permissions":"#<Sawyer::Resource:0x00007ff736249660>"
  repos.map(&:marshal_dump)
       .map(&:first)
       .map(&:to_json)
       .map { |repo_json| puts repo_json }
else
  abort usage
end

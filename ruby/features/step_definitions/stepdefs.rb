# frozen_string_literal: true

require 'github_tools'

Before do
  @all_repos = [{ name: 'Optimus Prime', topics: ['prime'] },
                { name: 'Rodimus Prime', topics: ['prime'] },
                { name: 'Ultra Magnus', topics: ['prime'] },
                { name: 'Grimlock', topics: ['dinobot'] },
                { name: 'Slag', topics: ['dinobot'] },
                { name: 'Swoop', topics: ['dinobot'] }]

  @dinobot_repos = @all_repos.select { |repo| repo[:topics].include? 'dinobot' }
end

Given 'no topic is specified' do
  @topic = nil
  @repos = @all_repos
end

Given 'a valid org is specified' do
  @org = 'AcmeInc'
end

Given 'an initialized client is supplied' do
  @client = mock 'client'
  @client.stubs(:org_repos).returns @repos
  @client.stubs(:search_repos).returns OpenStruct.new(items: @repos, total_count: @repos.length)
end

When('I attempt to retrieve matching Repositories') do
  capture_stderr { @result = GitHubTools.org_repos @topic, @org, @client }
end

Then('the result should be all of the org’s repositories') do
  expect(@result).to eq(@all_repos)
end

Given 'that the GitHub API is unreachable' do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('an exception should be raised') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given 'that the user has hit the GitHub API’s rate limits' do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('a TooManyRequests exception should be raised') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given 'a valid topic is specified' do
  @topic = 'dinobot'
  @repos = @dinobot_repos
end

Then('the result should be those of the org’s repositories with that topic') do
  expect(@result).to eq(@dinobot_repos)
end

Given 'the client returns exactly 100 repositories with total_count > 100' do
  @repos = @all_repos[0..4] * 20
  # Gotta change the search_repos stub to return this new value of @repos and a total_count > 100
  @search_result = OpenStruct.new items: @repos, total_count: 101
  @client.stubs(:search_repos).returns @search_result
end

Then('the result should be those one hundred repositories') do
  expect(@result.length).to eq(100)
end

Then('a warning message should have been printed to stderr') do
  expect(@stderr_output).to include('additional matching repos')
end

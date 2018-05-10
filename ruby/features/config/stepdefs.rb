# frozen_string_literal: true

require 'config'

Given 'the environment does not contain GITHUB_ORG nor GITHUB_TOKEN' do
  ENV.delete 'GITHUB_ORG'
  ENV.delete 'GITHUB_TOKEN'
end

Given 'the environment DOES contain the variable UNDERWEAR_TYPE with the value boxers' do
  ENV['UNDERWEAR_TYPE'] = 'boxers'
end

Given 'the environment does NOT contain the variable UNDERWEAR_TYPE' do
  ENV.delete 'UNDERWEAR_TYPE'
end

When 'the config value underwear_type is requested, specified as a lower-case string' do
  @result = Config['underwear_type']
end

When 'the config value :underwear_type is requested, specified as a lower-case symbol' do
  @result = Config[:underwear_type]
end

Then 'the result should be boxers' do
  expect(@result).to eq 'boxers'
end

Then 'the result should be nil' do
  expect(@result).to eq nil
end

Given 'all the required environment variables exist with INvalid values' do
  ENV['GITHUB_ORG'] = ''
  ENV['GITHUB_TOKEN'] = ''
end

Given 'all the required environment variables exist with VALID values' do
  ENV['GITHUB_ORG'] = 'The Rebellion'
  ENV['GITHUB_TOKEN'] = 'R2D2+C3P0'
end

When 'validate! is called' do
  @result = Config.validate!
end

# It’s not idiomatic to include a Then in a When but the combination of Cucumber and Mocha forces
# this, because the expectation (the Then) can only be set up in the When because the When runs
# before the Then.
When 'validate! is called then #abort should be called with a relevant message' do
  expectation = Config.expects(:abort)
                      .with(includes('The environment variable', 'must contain the GitHub'))

  # Because the normal abort exits the method, we’ll raise an exception to emulate that behavior.
  expectation.raises(RuntimeError, 'this is a hack')

  result, _stdout, _stderr = capture { Config.validate! }

  # It’s not idiomatic to include expectations in a When but as per the comment at the top, the
  # combination of Cucumber and Mocha forces this.
  expect(result).to be_instance_of(RuntimeError)
  expect(result.message).to include('this is a hack')
end

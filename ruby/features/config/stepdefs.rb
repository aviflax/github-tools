# frozen_string_literal: true

require 'config'

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

Given 'all the required environment variables exist' do
  ENV['ORG'] = ''
  ENV['TOKEN'] = ''
end

Given 'all the required environment variables have valid values' do
  ENV['ORG'] = 'The Rebellion'
  ENV['TOKEN'] = 'R2D2+C3P0'
end

When 'validate! is called' do
  Kernel.stubs(:abort)
  @result = Config.validate!
end

Then 'Kernel#abort should be called with a relevant message' do
  Kernel.expects(:abort)
        .with { |val| val.include?('environment variable') && val.include?('must contain') }
        .returns(nil)
end

Given 'the environment is missing ORG and TOKEN' do
  ENV.delete 'ORG'
  ENV.delete 'TOKEN'
end

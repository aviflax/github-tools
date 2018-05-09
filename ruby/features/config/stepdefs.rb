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

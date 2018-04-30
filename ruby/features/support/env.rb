# frozen_string_literal: true

$LOAD_PATH.unshift '/work/src'

require 'mocha/api'

World(Mocha::API)

Before do
  mocha_setup
end

After do
  mocha_verify
ensure
  mocha_teardown
end

module Mocha
  # Extend existing module (that we’re using as our Cucumber “world”) to capture output to $stderr
  # in @stderr_output. RSpec has a feature for this (#output) but it’d be very awkward to use with
  # Cucumber.
  module API
    def capture_stderr
      stderr_bak = $stderr
      $stderr = StringIO.new
      result = yield
      @stderr_output = $stderr.string
      $stderr = stderr_bak
      result
    end
  end
end

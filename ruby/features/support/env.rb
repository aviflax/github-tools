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
  # Extend existing module (that we’re using as our Cucumber “world”) to return a block result
  # or any raised exception, and also capture and return any output to stdout and stderr.
  module API
    # rubocop:disable Metrics/MethodLength
    def capture
      stdout_bak = $stdout
      stderr_bak = $stderr
      $stdout = StringIO.new
      $stderr = StringIO.new

      result = begin
        yield
      rescue StandardError => err
        err
      end

      stdout = $stdout.string
      stderr = $stderr.string
      $stdout = stdout_bak
      $stderr = stderr_bak

      [result, stdout, stderr]
    end
    # rubocop:enable Metrics/MethodLength
  end
end

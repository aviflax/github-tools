# frozen_string_literal: true

# If you change this, make sure to keep this line in sync with the WORKDIR and COPY instructions in
# the Dockerfile, and with the directory structure (i.e. the source code is currently in ./src,
# relative to the Docker build context).
$LOAD_PATH.unshift '/work/src'

require 'mocha/api'

World Mocha::API

Before { mocha_setup }

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

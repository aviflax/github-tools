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

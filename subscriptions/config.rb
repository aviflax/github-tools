# Get the config from the environment and make it available.
module Config
  REQUIRED = [
    ['ORG',
     'The environment variable ORG must contain the GitHub “organization” name.'],
    ['TOKEN',
     'The environment variable TOKEN must contain the GitHub OAuth token.']
  ].freeze

  def self.validate!
    REQUIRED.each do |var, msg|
      val = ENV[var]
      unless val.is_a?(String) && !val.strip.empty?
        puts msg
        exit false
      end
    end
  end

  def self.[](name)
    ENV[name.to_s.upcase]
  end
end

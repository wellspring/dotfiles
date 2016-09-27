require 'rubygems'                       # Load rubygems (only needed in 1.8)
require 'irb/completion'                 # Enable completion with TAB key
require 'base64'                         # Because i use it often :p
require 'json'                           # Because i use it often :p
require 'yaml'                           # Because i use it often :p
require 'openssl'                        # Because i use it often :p

# Enable colorization
begin
  require 'wirble'                       # Wirble enables to color output like pry
  Wirble.init
  Wirble.colorize
rescue LoadError
end

# Enable hIRB enhanced features
begin
  require 'hirb'                         # Various enhancements for irb
  Hirb::View.enable
rescue LoadError
end

# Other stuff...
begin
  require 'what_methods'                 # Enable '3.88.what? 4' to show 'ceil' method
  require 'map_by_method'                # Easy usage of map method
  require 'pp'                           # Pretty print (pp) is like p, but with \n in Hash/Arrays...
  require 'awesome_print'                # Colored pretty print, for some special occasions :)
rescue LoadError
end

# Simple prompt (>> ) and auto indent (in for loops, ...)
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
#IRB.conf[:USE_READLINE] = false

# Load gems automatically
# if File.exists?('Gemfile') && Object.const_defined?('Bundle')
#   Bundle.require
# end

# Rails 2.x & 3.x
if ENV.include?('RAILS_ENV')
  if !Object.const_defined?('RAILS_DEFAULT_LOGGER')
    require 'logger'
    Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
  end

  def sql(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  if ENV['RAILS_ENV'] == 'test'
    require 'test/test_helper'
  end

elsif defined?(Rails) && !Rails.env.nil? # Rails 3
  if Rails.logger
    Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = Rails.logger
  end
  if Rails.env == 'test'
    require 'test/test_helper'
  end
else
  # nothing to do
end

# Other
def files
  Dir['*']
end

# Intro
intro = "Interactive Ruby Shell :: #{ENV["USER"]} @ Ruby(#{RUBY_VERSION})"
puts intro
intro.size.times { print '~' }
print "\n"


require 'rubygems' rescue nil # Load gems automatically
require 'irb/completion'      # Enable completion with TAB key
require 'map_by_method'       # Easy usage of map method
require 'what_methods'        # Enable '3.88.what? 4' to show 'ceil' method
require 'wirble'              # Wrible to use colorization
require 'hirb'                # Various enhancements for irb
require 'pp'                  # Pretty print (pp) is like p, but with \n in Hash/Arrays...
require 'awesome_print'       # Colored pretty print, for some special occasions :)
require 'base64'              # Because i use it often :p

# Enable colorization
Wirble.init
Wirble.colorize

# Enable hIRB enhanced features
Hirb::View.enable

# Simple prompt (>> ) and auto indent (in for loops, ...)
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
#IRB.conf[:USE_READLINE] = false

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

# Intro
intro = "Interactive Ruby Shell :: #{ENV["USER"]} @ Ruby(#{RUBY_VERSION})"
puts intro
intro.size.times { print '~' }
print "\n"


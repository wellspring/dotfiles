require 'rubygems'        # Load gems automatically
require 'irb/completion'  # Enable completion with TAB key
require 'map_by_method'   # Easy usage of map method
require 'what_methods'    # Enable '3.88.what? 4' to show 'ceil' method
require 'wirble'          # Wrible to use colorization
require 'pp'              # Pretty print (pp) is like p, but with \n in Hash/Arrays...
require 'base64'          # Because i use it often :p

# Enable colorization
Wirble.init
Wirble.colorize

# Simple prompt (>> ) and auto indent (in for loops, ...)
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true


# Intro
intro = "Interactive Ruby Shell :: #{ENV["USER"]} @ Ruby(#{RUBY_VERSION})"
puts intro
intro.size.times { print '~' }
print "\n"

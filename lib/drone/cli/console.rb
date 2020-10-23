#!/usr/bin/env ruby

if $drone_testing
  puts "⚠️  Test mode enabled"
  r_module = 'drone/cli/testing'
else
  r_module = 'drone'
end

puts "Ready to receive Drone commands. Type \"exit\" to quit."

# When running as gem
if system('pry -v &>/dev/null')
  system("pry -r #{r_module}")
else
  system("irb -r #{r_module}")
end

# For local dev
# require r_module
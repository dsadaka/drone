module Server
  def self.state; @state end
  def self.state=(s); @state=(s) end

  require 'drone/colorize'
  require 'server/action'
  require 'server/state'
  require 'socket'
end



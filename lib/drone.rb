# Drone module and requires

module Drone
  # Flag for testing
  attr_accessor :testing, :os, :ip, :port

  def self.testing; @testing end
  def self.testing=(t); @testing=(t) end
  def self.os; @os end

  # Set the operating system
  case RUBY_PLATFORM
  when /darwin/
    @os = :macos
  when /linux/
    @os = :linux
  when /mingw/
    @os = :windows
  end
end

GRAVITY_ACCEL = 9.8

require 'drone/colorize'
require 'drone/state'
require 'drone/client'
require 'drone/dsl'
require 'drone/action'

# Add DSL
extend Drone::DSL

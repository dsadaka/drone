# Drone::DSL
# Define Drone domain-specific language

module Drone
  module DSL

    # Warn Linux and Windows users to manually connect to Wi-Fi, for now
    unless Drone.os == :macos
      puts "Linux and Windows users:".bold,
        "  Manually connect to Drone Wi-Fi before running the `connect` command"
    end

    # Connect to the drone
    def connect
      Drone::Client.connect
    end

    # Is the drone connected?
    def connected?
      Drone::Client.connected?
    end

    # Disconnect the drone
    def disconnect
      Drone::Client.disconnect
    end

    # Send a native Drone command to the drone
    def send(s)
      Drone::Client.send(s)
    end

    # Check if value is within the common movement range
    def in_move_range?(v)
      (20..500).include? v
    end

    # Takeoff and land
    [:take_off, :land, :hover, :stabilize, :tap, :break_engine].each do |cmd|
      define_method cmd do
        Drone::Client.return_wo_response send("#{cmd.to_s}")
      end
    end

    [:status].each do |cmd|
      define_method cmd do
        Drone::Client.return_w_response send("#{cmd.to_s}")
      end
    end


    # binding.pry

    # Move in a given direction
    [:move_up, :move_down, :move_left, :move_right, :move_forward, :move_back].each do |cmd|
      define_method cmd do |x|
        if in_move_range? x
          Drone::Client.return_wo_response send("#{cmd.to_s} #{x}")
        else
          puts "Movement must be between 20..500 cm"
        end
      end
    end

    # Turn clockwise or counterclockwise
    [:rotate_right, :rotate_left].each do |cmd|
      define_method cmd do |x|
        if (1..360).include? x
          Drone::Client.return_wo_response send("#{cmd.to_s} #{x}")
        else
          puts "Rotation must be between 1..360 degrees"
        end
      end
    end

  end
end

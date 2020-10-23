module Server
  # Perform actions
  # In real life this module would be sending command to the quadcopter's Electronic Speed Control (ESC)
  # pins as described in the README.  However, living in the academic world, with no real
  # craft to control, we are only setting the status values to reflect what would have happened

  # Also, if I'd had more time... I could've done some metaprogramming
  # to keep from having to repeat the status check for each method.

  class Action

    def take_off
      return false unless Server.state.off?
      Server.state.update_state(Server.state.takeoff_state)
    end

    def rotate_left(degrees)
      return false if Server.state.off?
      Server.state.update_direction(-1 * degrees.to_i)
    end

    def rotate_right(degrees)
      return false if Server.state.off?
      Server.state.update_direction(degrees.to_i)
    end

    def move_left(distance)
      return false if Server.state.off?
      Server.state.update_xy(:x, -1 * distance.to_i)
    end

    def move_right(distance)
      return false if Server.state.off?
      Server.state.update_xy(:x, distance.to_i)
    end

    def move_back(distance)
      return false if Server.state.off?
      Server.state.update_xy(:y, -1 * distance.to_i)
    end

    def move_forward(distance)
      return false if Server.state.off?
      Server.state.update_xy(:y, distance.to_i)
    end

    def stabilize
      return false if Server.state.off?
      Server.state.update_state(Server.state.hover_state)
    end

    def land
      return false if Server.state.off?
      Server.state.update_state(Server.state.landed_state)
    end

    def status
      Server.state.status
    end

    def tap
      puts "External force applied. Stabilizing".error
      stabilize
    end

    def break_engine
      puts "ERROR: Engine failure. Landing...".error
      land
    end

  end

end

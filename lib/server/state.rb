# Drone state

module Server

  class State

    attr_accessor :state

    STATUS_NAMES = %w(Off Takeoff Hovering Moving)
    TAKEOFF_ZPOS = 200

    # Call
    def initialize
      # Start out on the ground not moving
      @state = landed_state
    end


    # Takes a string
    def update_state(changes)
      @state.merge!(changes)
    end

    def update_direction(degrees)
      mod_by = degrees < 0 ? -360 : 360
      new_direction = (@state[:direction] += degrees.to_i).modulo(mod_by)
      @state[:direction] = new_direction
    end

    def update_xy(direction, distance)
      if direction == :x
        @state[:xpos] += distance
      elsif direction == :y
        @state[:ypos] += distance
      end
    end

    def landed_state
      {
          zpos: 0,
          xpos: 0,
          ypos: 0,
          roll: 0,
          pitch: 0,
          yaw: 0,
          vacc: 0,
          hacc: 0,
          direction: 0,
          status: enum_status('Off')
      }
    end

    def hover_state
      {
          roll: 0,
          pitch: 0,
          yaw: 0,
          hacc: 0,
          vacc: GRAVITY_ACCEL,
          status: enum_status('Hovering')
      }
    end

    def takeoff_state
      {
          zpos: TAKEOFF_ZPOS,
          xpos: 0,
          ypos: 0,
          roll: 0,
          pitch: 0,
          yaw: 0,
          vacc: GRAVITY_ACCEL,
          status: enum_status('Hovering')
      }
    end

    def status
      STATUS_NAMES[@state[:status]]
    end

    def enum_status(status)
      STATUS_NAMES.index(status)
    end
    
    # Make it easy to check status
    STATUS_NAMES.each do |status|
      define_method "#{status.downcase}?".to_sym do 
        return STATUS_NAMES[@state[:status]] == "#{status}"
      end
    end
    
  end
end

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
          status: STATUS_NAMES.index('Off')
      }
    end

    def hover_state
      {
          roll: 0,
          pitch: 0,
          yaw: 0,
          hacc: 0,
          vacc: GRAVITY_ACCEL,
          status: STATUS_NAMES.index('Hovering')
      }
    end

    def takeoff_state
      {
          zpos: TAKEOFF_ZPOS,
          xpos: 0,
          ypos: 0,
          roll: 0,
          pitch: 0,
          yaw: 0
      }
    end

    # Make it easy to check status
    STATUS_NAMES.each do |status|
      define_method "#{status.downcase}?".to_sym do 
        return STATUS_NAMES[@state[:status]] == "#{status}"
      end
    end
    
  end
end

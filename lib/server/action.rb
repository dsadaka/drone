module Server
  # Perform actions
  class Action

    def take_off
      return unless Server.state.off?
      Server.state.update_state(Server.state.takeoff_state)
    end

  end

end

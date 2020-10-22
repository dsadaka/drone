# Drone::Client
require 'socket'

module Drone
  module Client

    attr_accessor :ip, :port, :connected, :ping, :state

    class << self

      # Create a Drone UDP connection
      def connect(ssid = nil)

        # If already connected, disconnect
        if @connected
          puts "Reconnecting..."
          disconnect
        end

        # Set IP and port numbers
        @ip = 'localhost'
        @port = 8889

        # Create UDP client, bind to a previous source IP and port if available
        @client = UDPSocket.new unless @client
        if @source_ip && @source_port
          @client.bind(@source_ip, @source_port)
        end

        # Connect to destination, save IP and port assigned by the OS
        @client.connect(@ip, @port)
        @source_ip = @client.addr[3]
        @source_port = @client.addr[1]

        # Create server to get Drone state
        unless @state_server
          @state_server = UDPSocket.new
          @state_server.bind('0.0.0.0', 8890)
        end

        # Check to see if test server is up
        if Drone.testing
          print "Connecting to test server..."
          @client.send('command', 0)
          sleep 0.5
          unless read_nonblock
            puts "\n#{'Error:'.error} Could not find Drone test server.",
                 "Did you run `drone server` in another terminal window?"
            return false
          end
          puts "connected!"
        end

        @state = Drone::State.new

        # Drone should be connected over wifi and UDP
        @connected = true

        puts "Ready to fly! 🚁"; true
      end

      # Get Drone connection status
      def connected?
        if @connected
          true
        else
          puts "Drone is not yet connected. Run `connect` first."
          false
        end
      end

      # Disconnect the Drone
      def disconnect
        return false unless @connected
        unless Drone.testing
          @state.exit
          @ping.exit
        end
        @client.close
        @client = nil
        @connected = false
        true
      end

      # Read the UDP response without blocking
      def read_nonblock
        begin
          res = @client.recv_nonblock(256)
        rescue IO::WaitReadable
          res = nil
        rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL
          puts "#{'Error:'.error} Cannot communicate with Drone!"
          @connected
        end
      end

      # Send a native Drone command string
      def send(cmd)
        return false unless connected?
        while read_nonblock do end  # flush previous response data
        @client.send(cmd, 0)
        @client.recv(256).strip
      end

      # Change 'ok' and 'error' to boolean response instead
      def return_bool(res)
        case res
        when 'ok'
          true
        when 'error'
          false
        end
      end

      # Change string to number response instead
      def return_num(res)
        if res then res.to_i else res end
      end

    end

  end
end

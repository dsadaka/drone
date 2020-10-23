# A simple UDP server
require 'server'
require 'json'

PORT = 8889

server = UDPSocket.new
server.bind('localhost', PORT)

# Initialize on ground

Server.state = Server::State.new

@action= Server::Action.new

puts "Starting Drone test server...".bold, "Listening on udp://localhost:#{PORT}"
puts "Initial state: #{Server.state.state}"

loop do
  msg, addr = server.recvfrom(100)
  puts "#{"==>".green} Received: \"#{msg}\", from #{addr[3]}:#{addr[1]}"

  cmd, param = msg.split

  if @action.respond_to?(cmd)
    result = @action.send(cmd) unless param
    result = @action.send(cmd, param) if param
  else
    #=> 'ok' or 'error'
    result = 'ok'
  end

  response = if result
               { status: "ok", response: result, state: Server.state.state }
             else
               { status: "error", response: "Drone is #{Server.state.status}", state: Server.state.state }
             end

  bytes = server.send(response.to_json, 0, addr[3], addr[1])
  puts "#{"<==".blue} Sent: #{response}, #{bytes} bytes"
end

server.close

# A simple UDP server
require 'server'

PORT = 8889

server = UDPSocket.new
server.bind('localhost', PORT)

# Initialize on ground

Server.state = Server::State.new

@action= Server::Action.new

puts "Initial state: #{Server.state.state}"

puts "Starting Drone test server...".bold, "Listening on udp://localhost:#{PORT}"

loop do
  msg, addr = server.recvfrom(100)
  puts "#{"==>".green} Received: \"#{msg}\", from #{addr[3]}:#{addr[1]}"

  case msg
  when 'take_off'
    @action.take_off
  when 'speed?'
    #=> 1-100 cm/s
    res = "#{rand(1..100).to_f}\r\n"
  when 'battery?'
    #=> 0-100 %
    res = "#{rand(0..100)}\r\n"
  when 'time?'
    #=> time
    res = "#{rand(0..100)}s\r\n"
  when 'height?'
    #=> 0-3000 cm
    res = "#{rand(0..3000)}dm\r\n"
  when 'temp?'
    #=> 0-90 °C
    res = "83~86C\r\n"
  when 'attitude?'
    #=> pitch roll yaw
    res = "pitch:-8;roll:3;yaw:2;\r\n"
  when 'baro?'
    #=> m
    res = "-80.791573\r\n"
  when 'acceleration?'
    #=> x y z
    res = "agx:-138.00;agy:-51.00;agz:-989.00;\r\n"
  when 'tof?'
    #=> 30-1000 cm
    res = "#{rand(30..1000)}mm\r\n"
  when 'wifi?'
    #=> snr
    res = "90\r\n"
  when 'whatever'
    res = "unknown command: whatever"
  else
    #=> 'ok' or 'error'
    res = 'ok'
  end

  bytes = server.send(res.to_s, 0, addr[3], addr[1])
  puts "#{"<==".blue} Sent: #{res.inspect}, #{bytes} bytes"
  puts "State #{Server.state.state}"
end

server.close

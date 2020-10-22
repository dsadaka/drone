libx = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)

$drone_testing = true
require 'drone/cli/console'



$LOAD_PATH.unshift("./")
$LOAD_PATH.unshift("../")
$LOAD_PATH.unshift("../..")
require "rinda/ring"
require "rinda/tuplespace"


DRb.start_service
Rinda::RingServer.new(Rinda::TupleSpace.new, 1337)
DRb.thread.join
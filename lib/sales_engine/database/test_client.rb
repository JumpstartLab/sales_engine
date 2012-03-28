require "rinda/ring"
require "awesome_print"
require "./database"

DRb.start_service
ap "here!"
ring_server = Rinda::RingFinger.primary
ap "there!"
SalesEngine::Database.instance
ap "and everywhere!"
db_service = ring_server.read([:database_service,nil,nil,nil])
ap "got my db!"
ap db_service
db = db_service[2]
ap db.inspect
DRb.thread.join
$LOAD_PATH.unshift('lib','lib/sales_engine/','spec').uniq!
Dir["./lib/sales_engine/*.rb"].each {|file| require file }

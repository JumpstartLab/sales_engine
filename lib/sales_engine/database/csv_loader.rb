
require "./database"
require "./data_cleaner"
require "drb"
require "rinda/ring"
require "csv"

class CSVLoader
  include DRbUndumped
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  attr_reader :db, :ring_server

  def initialize
    @ring_server = Rinda::RingFinger.primary
    db_service = ring_server.read([:database_service,nil,nil,nil])
    @db = db_service[2]
  end

  def load_file(filename)
    file = load(filename)
    method_name = filename.gsub("s.csv","")
    klass_name = method_name.camelize
    klass = Kernel.const_get(klass_name)
    instances = file_to_objects(file, klass)
    send_instances_to_db(method_name, instances)
  end

  def load(filename)
    CSV.open("./unoriginal_data/#{filename}", CSV_OPTIONS)
  end

  def file_to_objects(file, klass)
    file.collect do |line|
      klass.new(line)
    end
  end

  def send_instances_to_db(method_name, instances)
    self.db.load_class_instances(method_name, instances)
  end
end

class String
  def camelize
    split("_").map{ |w| w.capitalize }.join
  end
end
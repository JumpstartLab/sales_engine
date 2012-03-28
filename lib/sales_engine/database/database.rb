$LOAD_PATH.unshift("./")
$LOAD_PATH.unshift("../")
$LOAD_PATH.unshift("../..")
require "./class_methods"
require "drb"
require "./csv_loader"
require "rinda/ring"
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'
require 'class_methods'


module SalesEngine
  class Database
   ATTRIBUTES = [:transaction, :customer, :item, :invoice_item,
    :merchant, :invoice, :all_transactions, :all_customers, :all_items,
    :all_invoice_items, :all_merchants, :all_invoices, :ring_server]
    FILE_ARRAY = ["merchants.csv","items.csv","invoices.csv",
      "invoice_items.csv","customers.csv","transactions.csv"]
      include Singleton
      include DRbUndumped
      include AccessorBuilder
      HASHES = [:transaction, :customer, :item, :invoice_item,
        :merchant, :invoice]
        ARRAYS = [:all_transactions, :all_customers, :all_items,
          :all_invoice_items, :all_merchants, :all_invoices]

          def initialize()
            ap "let's get it on"
            DRb.start_service
            init_instance_variables
            add_self_to_ring_server
            create_csv_loaders
          end

          def add_self_to_ring_server
            self.ring_server.write([:database_service,:Database,
              self, "Database"])
          end

          def init_instance_variables
            init_hashes
            init_arrays
            @ring_server = Rinda::RingFinger.primary
          end

          def init_hashes
            HASHES.each do |hash|
              hash_init = Hash.new do |hash1,key1|
                hash1[key1] = Hash.new do |hash2, key2|
                  if key2.to_s.end_with?("s")
                    hash2[key2] = []
                  end
                end 
              end
              send("#{hash}=", hash_init)
            end
          end

          def init_arrays
            ARRAYS.each do |array|
              send("#{array}=", [])
            end
          end

          def create_csv_loaders
            FILE_ARRAY.map do |filename|
              Thread.new do
                csv_loader = CSVLoader.new
                csv_loader.load_file(filename)
              end
            end.each(&:join)
            puts "I made them!"
          end
        end
      end




















$LOAD_PATH.unshift("./")
require "./class_methods"
require "drb"
require "rinda/ring"

module SalesEngine
  class Database
    include Singleton
    include DRbUndumped
    include AccessorBuilder
    ATTRIBUTES = [:transaction, :customer, :item, :invoice_item,
      :merchant, :invoice, :all_transactions, :all_customers, :all_items,
      :all_invoice_items, :all_merchants, :all_invoices, :ring_server,
      :loaders]
      HASHES = [:transaction, :customer, :item, :invoice_item,
        :merchant, :invoice]
        ARRAYS = [:all_transactions, :all_customers, :all_items,
          :all_invoice_items, :all_merchants, :all_invoices]

          def initialize(filename_array)
            init_instance_variables
            add_self_to_ring_server
            create_csv_loaders(filename_array.size)
            load_csvs
          end

          def add_self_to_ring_server
            DRb.start_server
            self.ring_server([:database_service,:Database, self, "Database"])
            DRb.thread.join
          end

          def init_instance_variables
            init_hashes
            init_arrays
            @loaders = []
            @ring_server = Rinda::RingServer.primary
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

        end
      end
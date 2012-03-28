 require 'singleton'

 module SalesEngine
   class Database
     include Singleton
     attr_accessor :db

    def self.get_dates
      raw_date = DateTime.now
      clean_date = raw_date.strftime("%Y-%m-%d %H:%M:%S")
      return raw_date, clean_date
    end

     private_class_method :new
   end
 end 

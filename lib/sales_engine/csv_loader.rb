require 'csv'
module SalesEngine
	class CSVLoader
		CSV_OPTIONS = {:headers => true, :header_converters => :symbol}


		def self.load(filename)
			file = CSV.open(filename, CSV_OPTIONS)
			results = file.collect { |line| line.to_hash }
			results
		end
	end
end

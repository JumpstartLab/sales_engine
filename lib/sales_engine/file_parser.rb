require 'csv'

module SalesEngine
  class FileParser
    CSV_OPTIONS = {
      :headers => true,
      :header_converters => :symbol
    }

    def parse(filename)
      filename ||= ''
      error_msg = "#{filename} does not exist."
      raise ArgumentError, error_msg unless File.exist? filename

      CSV.open(filename, CSV_OPTIONS).map { |x| Hash[x] }
    end
  end
end

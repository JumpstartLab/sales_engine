module SalesEngine
	module Searchable
		def all
			self.records
		end

		def random
			self.records.sample
		end

		def method_missing(method, *args, &block)
			command = method.to_s.split('_')
			if command[0..1] == ["find", "by"]
				field = command[2..-1].join('_')
				return find_by(field, *args) if self.records.first.respond_to?(field.to_sym)
			elsif command[0..2] == ["find", "all", "by"]
				field = command[3..-1].join('_')
				return find_all_by(field, *args) if self.records.first.respond_to?(field.to_sym)
			end
		  super(method, *args, &block)
		end

		#FIX THIS TO NOT TRUST THAT ID = INDEX
		def find_by_id(id)
			records[id-1]
		end

		def find_by(attribute, query)
			find_all_by(attribute, query).first
		end

		def find_all_by(attribute, query)
			if query.is_a? String
				all.select { |record| record.send(attribute.to_sym).to_s.downcase == query.downcase}
			else
				all.select { |record| record.send(attribute.to_sym) == query}
			end
		end
	end
end

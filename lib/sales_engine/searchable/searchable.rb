module SalesEngine
  module Searchable
    def all
      self.records.all
    end

    def random
      all.sample
    end

    def method_missing(method, *args, &block)
      command = method.to_s.split('_')
      if command[0..1] == ["find", "by"]
        field = command[2..-1].join('_')
        return find_by(field, *args) if valid_field?(field)
      elsif command[0..2] == ["find", "all", "by"]
        field = command[3..-1].join('_')
        return find_all_by(field, *args) if valid_field?(field)
      end
      super(method, *args, &block)
    end

    def valid_field?(field)
      all.first.respond_to?(field.to_sym)
    end

    def find_by_id(id)
      records.find_by_id(id)
    end

    def find_by(attribute, query)
      find_all_by(attribute, query).first
    end

    def find_all_by(attribute, query)
      if query.is_a? String
        all.select do |record|
          record.send(attribute.to_sym).to_s.downcase == query.downcase
        end
      else
        all.select do |record|
          record.send(attribute.to_sym) == query
        end
      end
    end
  end
end

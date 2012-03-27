$LOAD_PATH.unshift('lib','lib/sales_engine/','spec').uniq!
Dir["./lib/sales_engine/*.rb"].each {|file| require file }

module SalesEngine
  def self.startup
    load
  end

  def self.load(filename)
    data = SalesEngine::FileParser.new.parse(filename)

    model_class = convert_to_class(filename)

    data.each do |attributes|
      model_class.new(attributes)
    end
  end

  def self.convert_to_class(full_path)
    filename = full_path.split('/').last.split('.').first
    class_name = filename[0..-2].split('_').map(&:capitalize).join('')
    SalesEngine.const_get(class_name)
  end
end

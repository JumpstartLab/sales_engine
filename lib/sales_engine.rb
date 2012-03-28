$LOAD_PATH.unshift('lib','lib/sales_engine/','spec').uniq!
Dir["./lib/sales_engine/*.rb"].each {|file| require file }

module SalesEngine
  def self.startup(directory)
    load_directory(directory, :index => true)
  end

  def self.load(filename)
    data = SalesEngine::FileParser.new.parse(filename)
    model_class = convert_to_class(filename)

    data.each do |attributes|
      model_class.new(attributes).inspect
    end
  end

  def self.convert_to_class(full_path)
    filename = full_path.split('/').last.split('.').first
    class_name = filename[0..-2].split('_').map(&:capitalize).join('')
    SalesEngine.const_get(class_name)
  end

  def self.load_directory(directory, options = {})
    Dir.foreach(directory) do |filename| 
      load("#{directory}/#{filename}") if filename.match(/csv/)
    end

    if options[:index]
      Thread.new do 
        t = Time.now
        puts "indexing everything!"
        SalesEngine::Persistence.instance.index(:id)
        puts "Indexing completed in #{Time.now - t} seconds!"
      end
    end
  end
end

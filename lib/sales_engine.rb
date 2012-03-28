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
    if cache_exists?(directory)
      load_cache(directory)
    else
      Dir.foreach(directory) do |filename| 
        load("#{directory}/#{filename}") if filename.match(/csv/)
      end
      create_cache(directory)
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

  def self.cache_exists?(directory)
    File.exists?(directory + '/cache.dump')
  end

  def self.load_cache(directory)
    data = Marshal.load(File.open(directory + '/cache.dump', 'r'))
    SalesEngine::Persistence.instance.import(data)
  end

  def self.create_cache(directory)
    data = Marshal.dump(SalesEngine::Persistence.instance.dump_data)
    File.open(directory + '/cache.dump', 'w') { |f| f.write data }
  end
end

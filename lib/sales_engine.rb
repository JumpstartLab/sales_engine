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
    if cache_valid?(directory)
      load_cache(directory)
    else
      Dir.foreach(directory) do |filename| 
        load("#{directory}/#{filename}") if filename.match(/csv/)
      end
      create_cache(directory)
    end

    if options[:index]
      t = Time.now
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.insert_index(:merchant_id, SalesEngine::Invoice)
      SalesEngine::Persistence.instance.insert_index(:customer_id, SalesEngine::Invoice)
      SalesEngine::Persistence.instance.insert_index(:merchant_id, SalesEngine::Item)
      SalesEngine::Persistence.instance.insert_index(:item_id, SalesEngine::InvoiceItem)
      SalesEngine::Persistence.instance.insert_index(:invoice_id, SalesEngine::InvoiceItem)
      SalesEngine::Persistence.instance.insert_index(:invoice_id, SalesEngine::Transaction)
      puts "\nIndexing completed in #{Time.now - t} seconds!"
    end
  end

  def self.cache_valid?(directory)
    all_caches = Dir[directory + '/*.cache']

    unless all_caches.empty?
      filename = all_caches.first.split('.').first.split('/').last
      filename == generate_filename(directory)
    else
      false
    end
  end

  def self.load_cache(directory)
    cache_path = "#{directory}/#{generate_filename(directory)}.cache"
    data = Marshal.load(File.open(cache_path, 'r'))
    SalesEngine::Persistence.instance.import(data)
  end

  def self.create_cache(directory)
    destroy_all_caches(directory)
    data = Marshal.dump(SalesEngine::Persistence.instance.dump_data)
    cache_path = "#{directory}/#{generate_filename(directory)}.cache"
    File.open(cache_path, 'w') { |f| f.write data }
  end

  def self.destroy_all_caches(directory)
    Dir[directory + '/*.cache'].map { |f| File.delete(f) }
  end

  def self.generate_filename(directory)
    filenames = Dir[directory + '/*.csv']
    timestamps = filenames.map { |f| File.stat(f).mtime }

    Digest::MD5.hexdigest(filenames.join.to_s + timestamps.join.to_s)
  end
end

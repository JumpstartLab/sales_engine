guard 'rspec', :cli => "--colour --format=d" do
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/(.+)_spec\.rb$})     
end

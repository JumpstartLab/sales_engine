# A sample Guardfile
# More info at https://github.com/guard/guard#readme
# to run write, bundle exec guard

guard 'rspec', :cli => "--colour --format=d" do
  watch(%r{^(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end


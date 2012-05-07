test.rb
class << Class
 def self.self
  self end || self.self
end
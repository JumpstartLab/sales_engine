# $LOAD_PATH.unshift('./')
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'
require 'ruby-prof'
require 'time'

# RubyProf.start
SalesEngine.startup
# result = RubyProf.stop

# # printer = RubyProf::FlatPrinter.new(result)
# # printer.print(STDOUT, :min_percent=>1)

# printer = RubyProf::GraphHtmlPrinter.new(result)
# x = File.open('profile.html', 'w')
# printer.print(x, :min_percent=>1)
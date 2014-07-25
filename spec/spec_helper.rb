require 'coveralls'
Coveralls.wear!

require 'rubygems'
require 'evernote_utils'
require 'factory_girl'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.definition_file_paths << Pathname.new("../factories.rb")
FactoryGirl.find_definitions # required

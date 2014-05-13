require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

# CSV.open('output.csv', 'w') do |w|
#   CSV.open('words.csv', 'r') do |r|
#     reader.each do |row|
#       # extract plain text from ENUtils::Note#content, which is an ENML document.
#       w << [row[0], row[1], Nokogiri::XML(row[2]).elements.first.text.gsub(/^\n|\n$/,')]
#     end
#   end
# end

###################################################
require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'pry'
require 'evernote_utils'

e = ENUtils::Core.new("xxxxxxxxxxx")

binding.pry

# notebook_archive = e.notebooks(name: 'Archive').first
# tag_english = e.tags(name: 'english').first
# results = []
# results << e.notes(notebook: notebook_archive, tag: tag_english, limit: 50, offset: 0)
# results << e.notes(notebook: notebook_archive, tag: tag_english, limit: 50, offset: 50)
# results << e.notes(notebook: notebook_archive, tag: tag_english, limit: 50, offset: 100)
# results.flatten!
# results.each{|n| n.set_content! }
#
# require 'csv'
# CSV.open('hoge.csv', 'w') do |csv|
#   results.each do |n|
#     csv << [n.created, n.title, n.content]
#   end
# end

require 'rubygems'
require 'json'
require 'builder'
require 'erb'


def write_file filename, binding
  template = File.read("kindle_templates/#{filename}.erb")
  File.open("tmp/#{filename}", "w") {|f| f.puts ERB.new(template).result binding}
end

todays_date = DateTime.now.to_s
stories = JSON.parse(File.open('tmp/stories.json').read)

stories.each_with_index do |story, index|
  story_template = ERB.new(File.read('kindle_templates/story.html.erb'))
  File.open("tmp/story#{index}.html", "w") {|f| f.puts story_template.result binding } 
end
["breakfast.opf", "breakfast.ncx", "toc.html", "intro.html"].each { |filename| write_file filename, binding }
require 'rubygems'
require 'json'
require 'builder'
require 'erb'

todays_date = DateTime.now.to_s
stories = JSON.parse(File.open('tmp/stories.json').read)

stories.each_with_index do |story, index|
  story_template = ERB.new(File.read('kindle_templates/story.html.erb'))
  File.open("tmp/story#{index}.html", "w") {|f| f.puts story_template.result binding } 
end

opf_template = ERB.new(File.read('kindle_templates/breakfast.opf.erb'))
File.open("tmp/breakfast.opf", "w") {|f| f.puts opf_template.result binding } 

ncx_template = ERB.new(File.read('kindle_templates/breakfast.ncx.erb'))
File.open("tmp/breakfast.ncx", "w") {|f| f.puts ncx_template.result binding }

toc_template = ERB.new(File.read('kindle_templates/toc.html.erb'))
File.open("tmp/toc.html", "w") {|f| f.puts toc_template.result binding }

intro_template = ERB.new(File.read('kindle_templates/intro.html.erb'))
File.open("tmp/intro.html", "w") {|f| f.puts intro_template.result binding }
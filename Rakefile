require 'open-uri'
require 'nokogiri'

task :default do
  sh "rm -rf tmp/"
  sh "mkdir -p tmp/images"
  sh "rm -rf target/"
  sh "mkdir target"
  
  doc = Nokogiri::HTML(open("http://www.breakfastpolitics.com/index/atom.xml"))
  today = doc.xpath('.//entry').first.xpath('.//link').first['href']
  
  sh "coffee breakfast-coffee.coffee #{today}"
  sh "bundle exec ruby xml_generator.rb"
  sh "cp kindle_templates/cover.png tmp/"
  filename = "breakfast_#{Time.now.strftime("%Y-%m-%d")}.mobi"
  sh "bin/kindlegen tmp/breakfast.opf -o #{filename}" do |ok, res|
    ok = true
  end
  sh "cp tmp/#{filename} target/"
  if File.directory?("/Volumes/Kindle/documents/")
    sh "cp target/#{filename} /Volumes/Kindle/documents/" 
  else
    puts "Skipped copying to Kindle."
  end
  puts "done"
end
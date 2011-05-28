task :default do
  sh "rm -rf tmp/"
  sh "mkdir tmp"
  sh "rm -rf target/"
  sh "mkdir target"
  
  sh "coffee breakfast-coffee.coffee http://www.breakfastpolitics.com/index/2011/05/wednesday-2.html"
  sh "bundle exec ruby xml_generator.rb"
  sh "cp kindle_templates/cover.png tmp/"
  filename = "breakfast_#{Time.now.strftime("%Y-%m-%d")}.mobi"
  sh "bin/kindlegen tmp/breakfast.opf -o #{filename}" do |ok, res|
    ok = true
  end
  sh "cp tmp/#{filename} target/"
  puts "done"
end
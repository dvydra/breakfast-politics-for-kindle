task :default do
  sh "coffee breakfast-coffee.coffee"
  sh "rm tmp/*"
  sh "bundle exec ruby xml_generator.rb"
  sh "cp kindle_templates/cover.png tmp/"
  sh "bin/kindlegen tmp/breakfast.opf" {|ok, res| ok = true }
  sh "cp tmp/breakfast.mobi target/"
  puts "done"
end
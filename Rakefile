task :default do
  sh "rm -rf tmp/"
  sh "mkdir tmp"
  sh "rm -rf target/"
  sh "mkdir target"
  
  sh "coffee breakfast-coffee.coffee"
  sh "bundle exec ruby xml_generator.rb"
  sh "cp kindle_templates/cover.png tmp/"
  sh "bin/kindlegen tmp/breakfast.opf" do |ok, res|
    ok = true
  end
  sh "cp tmp/breakfast.mobi target/"
  puts "done"
end
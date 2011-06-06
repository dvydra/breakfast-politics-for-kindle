require 'rubygems'
require 'json'
require 'builder'
require 'erb'
require 'nokogiri'
require 'open-uri'
require 'uri'

def write_file filename, binding
  template = File.read("kindle_templates/#{filename}.erb")
  File.open("tmp/#{filename}", "w") {|f| f.puts ERB.new(template).result binding}
end

def fairfax_hack story
  story['content'].gsub!("<small>Advertisement: Story continues below</small>", "")
  story
end

def remove_video_player fragment
  fragment.search(".//div[contains(@class, 'overlay')]").each { |f| f.remove }
  fragment
end

def fix_story_body(story, index)
  story = fairfax_hack(story)
  fragment = Nokogiri::XML.fragment(story['content'])
  fragment = remove_video_player fragment
  
  fragment.search('.//img').each_with_index do |img, inner_index| 
    parsed_image_uri = URI.parse(img['src'])
    new_filename = "images/#{index}_#{inner_index}#{File.extname(parsed_image_uri.path)}"
    begin
      open("tmp/"+new_filename, 'wb') do |f|
        f << open(img['src']).read
      end
      img['src'] = new_filename
    rescue
      puts "failed to retrieve image #{img['src']}"
    end

  end
  story['content'] = fragment.to_s
  story
end

todays_date = DateTime.now.to_s
stories = JSON.parse(File.open('tmp/stories.json').read)

stories.each_with_index do |story, index|
  source = URI.parse(story['url']).host
  story_template = ERB.new(File.read('kindle_templates/story.html.erb'))
  story = fix_story_body(story, index)
  File.open("tmp/story#{index}.html", "w") {|f| f.puts story_template.result binding } 
end


["breakfast.opf", "breakfast.ncx", "toc.html", "intro.html"].each { |filename| write_file filename, binding }
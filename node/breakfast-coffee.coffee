require.paths.unshift "#{__dirname}/node_modules"
{select}    = require 'soupselect'
htmlparser  = require 'htmlparser'
http        = require 'http'
sys         = require 'sys'
readability = require 'readability'
url_lib     = require 'url'
fs          = require 'fs'
events      = require 'events'
Step        = require 'step'

stories = []

handler = new htmlparser.DefaultHandler (err, dom) ->
  if err
    sys.debug "Error: #{err}"
  else
    parsed = select dom, 'div.entry-body p a'
    stories = ([title, url] for {attribs: {href: url}, children: [raw: title]} in parsed)

parser = new htmlparser.Parser handler

dump_stories = (data) ->
  fs.writeFile 'bp.html', JSON.stringify(data), null

retrieve_all_stories = (host, path) ->
  http.get host: host, port: 80, path: path, (response) ->
    response.setEncoding 'utf8'
    body = ""
    response.on 'data', (chunk) -> body = body + chunk
    response.on 'end', ->
      parser.parseComplete body
      Step -> 
        group = this.group()
        stories.forEach (story) ->
          processStory story, group()
      , (err, data) ->
        if (err) then sys.debug err
        else
          return data
      , (err, callback) ->
        dump_stories(callback)


processStory = (story, callback) ->
  url_parts = url_lib.parse story[1]
  options =
    host: url_parts['host']
    port: 80
    path: url_parts['pathname']
  http.get options, (story_response) ->
    processStoryResponse story_response, callback

processStoryResponse = (story_response, callback) ->
  story_response.setEncoding 'utf8'
  story_body = ""
  story_response.on 'data', (chunk) -> story_body = story_body + chunk
  story_response.on 'end', ->
    readability.parse story_body, "", (result) ->
      callback null, result.content

#retrieve_all_stories('www.breakfastpolitics.com', '/index/2011/05/friday-1.html')
retrieve_all_stories('localhost', '/~dvydra/bp.html')
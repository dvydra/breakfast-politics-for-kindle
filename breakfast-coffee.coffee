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

dump_stories = (results) ->
  fs.writeFile 'tmp/stories.json', JSON.stringify(results) , null

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
      , (err, result) ->
        dump_stories result


processStory = (story, callback) ->
  url_parts = url_lib.parse story[1]
  title = story[0]
  options =
    host: url_parts['host']
    port: 80
    path: url_parts['pathname']
  http.get options, (story_response) ->
    story_response.setEncoding 'utf8'
    story_body = ""
    story_response.on 'data', (chunk) -> story_body = story_body + chunk
    story_response.on 'end', ->
      readability.parse story_body, "", (result) ->
        callback null, {title: title, url: story[1], content: result.content}

index_url = url_lib.parse process.argv[2]
retrieve_all_stories(index_url['host'], index_url['pathname'])
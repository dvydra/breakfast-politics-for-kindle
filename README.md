## Breakfast Politics for Kindle

This is horribly hacky at the moment, sorry.

Run the default `rake` task to retrieve all articles from [breakfastpolitics.com](http://breakfastpolitics.com), readability-ize them and generate a kindle-formatted file. 

You'll need a copy of [kindlegen](http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000234621) at `bin/kindlegen`
You'll also need to [install node.js](https://github.com/joyent/node/wiki/Installation)
Run a `bundle install` to retrieve the deps.
The generated mobi file will be in `target/`

Good luck. 

TODO:

- fix broken links and images from inside article bodies
- clean up story html beyond what readability does (remove header weather forecast crap, "continue after ad" stuff)
- parameterize stuff (retrieve the "current" url, etc)
- <strike>package node dependencies (http://www.google.com.au/search?sourceid=chrome&ie=UTF-8&q=npm+package.json)</strike>
- better rakefile
- actually just rewrite it from scratch with some test coverage :D



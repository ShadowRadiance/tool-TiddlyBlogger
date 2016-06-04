# TiddlyBlogger

TiddlyBlogger reads a blog on Google's Blogger platform and converts to a TiddlyWiki page containing the same content.

- TiddlyWiki is a single-file HTML+Javascript wiki
- Blogger is a platform by Google for create blogs

To run this application, you need an API Key from https://console.developers.google.com/apis/credentials

To run the tests for the tiddly_blogger gem, `cd tiddly_blogger`, then run either:
- `BLOGGER_API_KEY=<your-api-key> SLOW_TESTS=yes bundle exec rake test`
- `bundle exec rake test`

## Road Map

### Library and Command Line Interface

- Prove we can access Google's API to pull public information about a blog from its URL
- Inject text tiddlers verbatim into a base empty tiddlywiki
- Convert images referred to in blog to local images and replace img tags
- Output either an embedded base-64 image single file or a zip of the images and html file
- Ensure we can send either via email

### Web application Interface

- Build a web interface to allow a user to specify the url and options
  - Option A: Email me or I'll wait for the response (Either way, operation must be asynchronous)
  - Option B: Zip of HTML+Images or Single Large HTML file with Images embedded
- Handle bad URLs

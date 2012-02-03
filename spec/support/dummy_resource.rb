DUMMY_CONSUMER_KEY    = "key"
DUMMY_CONSUMER_SECRET = "shhh"
DUMMY_CONSUMER_SITE   = "http://example.com"

class DummyResource < OauthResource::Resource

  self.site            = DUMMY_CONSUMER_SITE
  self.consumer_key    = DUMMY_CONSUMER_KEY
  self.consumer_secret = DUMMY_CONSUMER_SECRET

end

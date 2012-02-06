# Oauth Resource

A module that enables ActiveResource objects to transparently speak OAuth 1.0

## Example Usage

```ruby
class User < OauthResource::Resource
  self.consumer_key    = Application::Example.config[:consumer_key]
  self.consumer_secret = Application::Example.config[:consumer_secret]
  
  # ... Proceed with normal ActiveResource usage ...
end
```

## Contributing

1. Fork the project
2. Create a feature/fix branch
3. Add your fix/feature (with tests)
4. Send a pull request

## TODO

Improve README.md

## License

Please see LICENSE.txt for copyright and licensing information.

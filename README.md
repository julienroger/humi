[![Maintainability](https://api.codeclimate.com/v1/badges/cb16c704067bcc8023a9/maintainability)](https://codeclimate.com/github/julienroger/humi/maintainability) [![Build Status](https://travis-ci.org/julienroger/humi.svg?branch=development)](https://travis-ci.org/julienroger/humi)

# Humi

The Humi Ruby Gem is a Ruby client for the [Humi API](https://docs.humi.ca).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "humi"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install humi

## Usage

### Token Authentication

```ruby
client = Humi.new(
  oauth_token:   'access_token',
  refresh_token: 'refresh-token',
  client_id:     'client-id',
  client_secret: 'client-secret',
  auth_callback: Proc.new { |x| puts x.to_s },
)
```

The client will use `refresh_token` automatically to request a new `access_token` if the existing `access_token` has expired

`auth_callback` is a proc that handles the authentication response from Humi when the `refresh_token` is used to obtain a new `access_token`. This allows the `access_token` and / or `refresh_token` to be saved for re-use later.


### Queries

TODO

```ruby
user = client.get_self
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/julienroger/humi.

## Credits

This gem was written by [Julien Roger](https://www.julienroger.com) for use with the [Humi API](https://docs.humi.ca).

This gem was heavily influenced by and borrows from:
* [Restforce](https://github.com/restforce/restforce)
* [The Instagram Ruby Gem](https://github.com/facebookarchive/instagram-ruby-gem)

## License

The gem is available as open source under the terms of the [MIT License](License.txt).

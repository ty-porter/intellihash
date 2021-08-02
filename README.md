# SmartHash

A fast implementation of hashes as objects, benchmarked against OpenStruct. It allows chaining hash attributes as method calls instead of standard hash syntax.

```ruby
hash = {
    foo: {
        bar: {
            baz: {
                bat: :bam
            }
        }
    }
}

hash.foo.bar.baz.bat

#=> :bam
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_hash'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install smart_hash

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ty-porter/smart_hash.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

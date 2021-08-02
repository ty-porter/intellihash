# Intellihash

A fast implementation of hashes as objects, benchmarked against OpenStruct. It allows chaining hash attributes as method calls instead of standard hash syntax.

Since an Intellihash extends the native Ruby `Hash`, this means instantiating a new intelligent hash is just as fast as a normal hash, _and_ you retain the ability to call all the normal instance methods on it.

```ruby
intellihash = {
    foo: {
        bar: {
            baz: {
                bat: :bam
            }
        }
    }
}

intellihash.foo.bar.baz.bat

#=> :bam
```

You can achieve similar results by converting your hash to an OpenStruct:

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

open_struct = OpenStruct.new(hash)
open_struct.foo.bar.baz.bat

#=> :bam
```

But you lose access to your instance methods, and pay a performance penalty to instantiate it!

```ruby
intellihash.size
#=> 1

open_struct.size
#=> nil
```

## Performance vs. OpenStruct

Creating an Intellihash is approximately 5x faster than instantiating an OpenStruct.

```              
                  user     system      total        real                
OpenStruct:   4.046875   0.906250   4.953125 (  4.979611)
Intellihash:  0.828125   0.125000   0.953125 (  0.956110)
```

See [Testing Performance](#testing-performance) for details on running benchmarks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'intellihash'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install intellihash

## Configuration

If you need to customize Intellihash, you may create a configuration:

```ruby
Intellihash.configure do |config|
    config.enabled                = true     # (Boolean) Default: false 
    config.default_format         = :symbol  # (Symbol)  Default: :symbol
    config.intelligent_by_default = false    # (Boolean) Default: false
end
```

### Options

- **enabled**
  - Whether Intellihash is enabled or not
  - You may wish to set this conditionally, such as enabling it only in a test environment
    - i.e. `config.enabled = Rails.env.test?`
  - **NOTE**: Once Intellihash is enabled, it cannot easily be disabled. Enable Intellihash with caution.
- **default_format**
  - Valid values: `:sym, :symbol, :str, :string, :any`
  - This determines the default storage and retrieval options
- **intelligent_by_default**
  - Whether newly created hashes are intelligent
  - When `false`, new hashes can still be converted to intelligent hashes via `hash.is_intelligent = true` or `hash.to_intellihash!`

### Rails

Place the above configuration in an initializer (such as `config/initializers/intellihash.rb`)

## Usage

### Instantiating an Intellihash

If you've configured Intellihash `intelligent_by_default = true`, you need to do nothing else as _all_ new hashes are Intellihashes.

However, if you prefer not to use this configuration, you can create an Intellihash from any existing hash:

```ruby
hash = { foo: :bar }

hash.is_intelligent?
#=> false

hash.is_intelligent = true
# or
hash.to_intellihash!

hash.is_intelligent? 
#=> true
```

### Methods

Intellihash-powered hashes can access values via method chaining:

```ruby
intellihash = { foo: :bar }

intellihash.foo

#=> :bar
```

They can also store values in a similar way:

```ruby
intellihash.baz = :bat
intellihash

#=> { foo: :bar, baz: :bat }
```

When configured correctly, they work even when the object contains arrays and other classes:

```ruby
Intellihash.configure do |config|
    config.enabled                = true
    config.intelligent_by_default = true
    config.default_format         = :any
end

intellihash = {
    a: {
        complicated: [
            {
                object: {
                    "containing_many" => {
                        types_of_things: Also::Works       
                    }
                }
            }
        ]
    }
}

intellihash.a.complicated.first.object.containing_many.types_of_things

#=> Also::Works
```

### Ambiguous Keys

When using an Intellihash that has an ambiguous key (i.e. the key exists both as a symbol and a string in the same hash), you can define which you would like to return at runtime:

```ruby
intellihash ={
    foo: :bar
    'foo' => 'bar'
}

intellihash.foo(from: :symbol) # or from: :sym
#=> :bar

intellihash.foo(from: :string) # or from: :str
#=> 'bar'
```

If you prefer, you can use the original hash syntax:

```ruby
intellihash[:foo]
#=> :bar

intellihash['foo']
#=> 'bar'
```

**NOTE**: Intellihashes always **store** values as the configured `default_format`, which defaults to `:symbol`. Override this in the config as needed, or use hash syntax: `intellihash['bar'] = 'bat'`.

### Collisions with Hash Methods

A powerful feature of Intellihash is the ability to use Ruby Hash instance methods on Intellihash. This also means that it's possible for some of the keys in the hash to collide with the names of the instance method you're trying to call. 

For instance, consider `Hash#size`, which returns the number of keys in the hash:

```ruby
intellihash = { size: 2 }

intellihash.size
#=> 1
```

For this reason, it's better to use hash syntax to fetch these keys:

```ruby
# Bad
intellihash.size

# Good
intellihash[:size]
intellihash.fetch(:size)
```

You _can_, however, **set** keys in the hash using these instance methods. This is not recommended as the syntax leads to confusion when attempting to access the key.

```ruby
intellihash.size = 3
intellihash

#=> { size: 3 }

intellihash.size
#=> 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Testing

### Unit Tests

Run unit tests:

```
bundle exec rspec
```

### Testing Performance

Run performance benchmarks:

```
bundle exec rspec --tag performance:true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ty-porter/intellihash.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

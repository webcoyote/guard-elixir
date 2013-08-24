# Guard::Elixir
[![Gem Version](https://badge.fury.io/rb/guard-elixir.png)](http://badge.fury.io/rb/guard-elixir)
[![Build Status](https://travis-ci.org/webcoyote/guard-elixir.png?branch=master)](https://travis-ci.org/webcoyote/guard-elixir)

Guard::Elixir is a [Guard](https://github.com/guard/guard) plugin that automatically runs tests for the [Elixir](http://elixir-lang.org/) language using "mix test".


## Installation


### Manual installation

```bash
gem install guard-elixir
```

### Installation using [Bundler](http://gembundler.com/).

Add Guard::Elixir to your `Gemfile`:

```ruby
group :development do
  gem 'guard-elixir'
end
```

and install it by running Bundler:

```bash
$ bundle
```


## Configuration

Add guard definition to your Guardfile by running the following command:

```bash
guard init elixir
```

Run guard to automatically run your Elixir tests

```bash
bundle exec guard start
```


### Standard Guardfile when using Guard::Elixir

```ruby
guard :elixir do
  watch(%r{^test/(.*)_test\.exs})
  watch(%r{^lib/(.+)\.ex$})           { |m| "test/#{m[1]}_test.exs" }
  watch(%r{^test/test_helper.exs$})   { "test" }
end
```

## More information

Please read [Guard usage doc](http://github.com/guard/guard#readme)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


# Author

Author:: [Patrick Wyatt](https://github.com/webcoyote) (pat@codeofhonor.com)

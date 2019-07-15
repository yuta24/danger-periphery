# danger-periphery

A [Danger](https://danger.systems/ruby/) plugin to identify unused code using [Periphery](https://github.com/peripheryapp/periphery).

This plugin is heavily inspired by [danger-swiftlint](https://github.com/ashfurrow/danger-ruby-swiftlint).

## Installation

Add this line to your Gemfile:

```rb
gem 'danger-rubocop'
```

[Periphery](https://github.com/peripheryapp/periphery) also needs to be installed before you run Danger.

## Usage

Add this to your `Dangerfile`:

```ruby
periphery.scan_files
```

## ToDo

- [ ] support of periphery's option parameters
- [ ] test

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

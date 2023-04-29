# Instant18n

Use OpenAI's GPT large-language model to power internationalization of the text in your Rails application. Extracted from real-world usage in [MagmaChat](https://github.com/magma-labs/magma-chat).

## Installation


Install the gem and add to the application's Gemfile by executing:

    $ bundle add instant18n

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install instant18n

Make sure to set `OPENAI_ACCESS_TOKEN` in your environment so that the library is able to access GPT.

## Usage

Invoke with `I18n.it` or simply `it` in your view templates. (Method is short for _instant translation_)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/obie/instant18n. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/obie/instant18n/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Instant18n project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/obie/instant18n/blob/main/CODE_OF_CONDUCT.md).

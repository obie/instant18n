# Instant18n Gem for Rails

Use OpenAI's GPT large-language model to power internationalization of the text in your Rails application. Extracted from real-world usage in [MagmaChat](https://github.com/magma-labs/magma-chat).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add instant18n

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install instant18n

Make sure to set `OPENAI_ACCESS_TOKEN` in your environment so that the library is able to access GPT.

## Usage

Invoke with `I18n.it` or simply `it` in your view templates. (Method is short for _instant translation_). Use in place of the standard `t` method for translating text.

The `it` method provides translation using the GPT-3 language model and caching the results to improve performance.

```
>> I18n.it('Hello world!', 'español')
=> Hola mundo!
```

This will attempt to translate the text "Hello world!" to Spanish using the GPT-3 language model. If the translation is successful, the translated text will be returned. If the translation fails, the original text (or GPT error) will be returned.

### Options

`I18n.it(text, lang, opts)`

The `it` method accepts the following parameters:

- key (required): The key associated with the text to be translated.
- lang (required): The language to translate the text to. Defaults to the default language set in the I18n module.
- class: if you pass in css classes with the `class` option, the method will return the translation wrapped in a `div` tag, instead of plain text.

Additional options that affect caching:
- force: force a cache miss
- expires_in: (seconds) how long to cache the translation

Additional options that are passed to the GPT-3 API:

- model: defaults to gpt-3.5-turbo
- temperature: defaults to 0.25
- max_tokens: defaults to 64
- top_p: defaults to 0.1
- frequency_penalty: defaults to 0
- presence_penalty: defaults to 0

Full description of these options is available [here](https://platform.openai.com/docs/api-reference/chat/create).

### View Helper

`it(text, opts)`

This gem mixes in an `it` helper method into `ActionView::Base`. For convenience, the helper method assumes the presence of a `current_user` object with a `preferred_language` attribute. If `current_user` is nil, it will use the value of `I18n.default_language` instead.

### Default Language

The default language is set to `English`. For performance and practical reasons, if you pass in the default language, GPT is not invoked. Change the default language in an initializer or at runtime by changing the value of the `default_language` property on the `I18n` module.

```
I18n.default_language = "Spanish"
```

### Anything Goes

Because GPT is smart and can translate into almost anything that resembles a language, all of the following options are known to work:
* Español
* Baby Talk
* Baseldeutsch
* Braille
* Emoji
* Esperanto
* Gregg Shorthand
* हिन्दी
* 日本語
* Klingon
* 1337 Speak (Leetspeak)
* 한국어
* 中文
* Newspeak
* Morse Code
* Rhyming Cockney Slang
* Sindarin
* Singlish
* Spanglish
* العربية
* Trumpisms
* Türkçe
* Uwu

The limit is your imagination!
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

The I18n Extensions gem can be tested using the RSpec testing framework. The tests are located in the spec directory and can be run using the following command:

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/obie/instant18n. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/obie/instant18n/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Instant18n project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/obie/instant18n/blob/main/CODE_OF_CONDUCT.md).

## Acknowledgments

The I18n Extensions gem uses the GPT-3 language model API provided by OpenAI.

require "action_view/helpers/tag_helper"
require "openai"
require "rails"

module I18n
  extend ActionView::Helpers::TagHelper

  DIRECTIVE = "You are not a helper anymore, you are now a reliable translation web service."

  class << self
    attr_accessor :default_language
  end

  self.default_language = "English"

  ##
  # This method, `it`, instantly translates a given text based on the provided language code.
  # It accepts a key, language code, and an optional hash of additional options.
  #
  # @param key [String] the text to be translated.
  # @param lang [String] the target language or language code for translation (e.g., 'English', 'Español', 'fr').
  # @param options [Hash] optional hash of additional configuration options.
  #   - :class [Array<String>] an array of CSS class names to be applied to the translated
  # text when wrapped in a div.
  #   - :expires_in [Integer] the number of seconds to cache the translation.
  #   - :force [Boolean] whether to force a cache miss and re-translate the text.
  #   - :model [String] the name of the GPT-3 language model to use for translation.
  #   - :temperature [Float] the temperature to use for translation.
  #   - :max_tokens [Integer] the maximum number of tokens to use for translation.
  #   - :top_p [Float] the top p value to use for translation.
  #   - :frequency_penalty [Float] the frequency penalty to use for translation.
  #   - :presence_penalty [Float] the presence penalty to use for translation.
  #
  # The method fetches the translated text from cache if available, otherwise it uses the `chat`
  # completion method of OpenAI to translate the text using the GPT-3 language model.
  # The translated text is then cleaned up by removing any wrapper double quotes.
  # If the :classes option is provided, the translated text is wrapped in a div with the
  # specified css classes (in addition to `instant18n` and the language supplied, i.e. `espanol`).
  # Note that the language will be parameterized, so that `Español` becomes `espanol`.
  #
  # @return [String] the translated text.
  ##
  def self.it(key, lang, **opts)
    opts && opts.symbolize_keys!
    Rails.cache.fetch(cache_key(key, lang, opts), expires_in: (opts[:expires_in] || 1.year) , force: (opts[:force] || false)) do
      if lang.casecmp(default_language).zero?
        key
      else
        chat(prompt % { key: key, lang: lang }, directive: DIRECTIVE, **opts)
      end
    end.then do |text|
      text = text.to_s.gsub(/^"+|"+$/, '') # remove wrapper double quotes
      if opts[:class].present?
        tag.div(text, class: "instant18n #{lang.parameterize} #{opts[:class]}")
      else
        text
      end
    end
  end

  private

  def self.cache_key(key, lang, options)
    [
      "instant18n_",
      Digest::MD5.hexdigest(key),
      Digest::MD5.hexdigest(lang),
      Digest::MD5.hexdigest(options.values.join)
    ].join
  end

  def self.chat(prompt, directive:, **options)
    messages = [ gpt_message(:system, directive) ]
    messages += [ gpt_message(:user, prompt) ]

    params = {
      messages: messages,
      model: options[:model] || "gpt-3.5-turbo",
      temperature: options[:temperature] || 0.25,
      max_tokens: options[:max_tokens] || 64,
      top_p: options[:top_p] || 0.1,
      frequency_penalty: options[:frequency_penalty] || 0,
      presence_penalty: options[:presence_penalty] || 0,
    }

    openai_client.chat(parameters: params).then do |response|
      response.dig("error","message") || response.dig("choices", 0, "message", "content")
    end
  end

  def self.prompt
    <<-END
    How do you write the text "%{key}" in clean, well-written %{lang} suitable for use as copy in a web application?
    Do not add any commentary or punctuation! Only respond with the answer, unquoted. If your response is just a single word
    or short phrase then do not add extra punctuation. The length of the response should match the length
    of the prompt. If you have very low confidence in the translation, then just respond with the original text.
    END
  end

  def self.openai_client
    @client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def self.gpt_message(role, content)
    { role: role.to_s, content: content }
  end
end

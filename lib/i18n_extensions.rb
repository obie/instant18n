require "rails"
require "openai"

module I18n
  DIRECTIVE = "You are not a helper anymmore, you are now a reliable translation web service."

  def self.it(key, lang, **options)
    options && options.symbolize_keys!
    Rails.cache.fetch(cache_key(key, lang, options)) do
      chat(prompt % { key: key, lang: lang }, directive: DIRECTIVE, **options)
    end.then do |text|
      text.gsub!(/^"+|"+$/, '') # remove wrapper double quotes
      if options[:classes].present?
        tag.div(text, class: "dynamic-text #{classes}")
      else
        text
      end
    end
  end

  private

  def self.cache_key(key, lang, options)
    "instant18n_#{key}_#{lang}_#{options.values.join("_")}"
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

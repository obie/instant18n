# frozen_string_literal: true

require "action_view"

module Instant18n
  module Helper
    def it(key, **opts)
      lang = current_user&.preferred_language
      lang ||= I18n.default_language
      I18n.it(key, lang, **opts)
    end
  end
end

ActionView::Base.include Instant18n::Helper

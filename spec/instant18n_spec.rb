# frozen_string_literal: true
require "dotenv/load"
require "rails"

class TestApp < Rails::Application
  config.cache_store = :memory_store
  config.eager_load = false
end

Rails.application.initialize!

RSpec.describe Instant18n do
  it "has a version number" do
    expect(Instant18n::VERSION).not_to be nil
  end

  it "does a translation", :aggregate_failures do
    expect(I18n.it("Save", "Español")).to eq("Guardar")
    expect(I18n.it("Save", "Pig Latin")).to eq("Avesay")
    expect(I18n.it("Save", "Emoji")).to eq("💾")
  end

  it "generates a translation in a div", :aggregate_failures do
    expect(I18n.it("Save", "Español", class: "foo bar")).to eq("<div class=\"instant18n espanol foo bar\">Guardar</div>")
  end

  it "does not call OpenAI when the language is English (default)", :aggregate_failures do
    # no instance of OpenAI::Client should be created or called
    expect(OpenAI::Client).not_to receive(:new)
    expect(I18n.it("Save", "English")).to eq("Save")
    expect(I18n.it("Save", "English", class: "foo bar")).to eq("<div class=\"instant18n english foo bar\">Save</div>")
  end
end

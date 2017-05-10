# frozen_string_literal: true

require "evil-client"
require "base64"

require_relative "types"
require_relative "ext/stringify_json_patch"

module Checkr
  module Canada
    # Checkr Canada API client
    class Client
      extend Evil::Client::DSL

      path = File.expand_path("../entities/*.rb", __FILE__)
      Dir[path].each { |file| require(file) }

      settings do
        param :api_key, Types::Strict::String
        option :version, Types::Coercible::Int, default: proc { 1 }
      end

      base_url do |settings|
        "https://api.checkr.com/ca/v#{settings.version}/"
      end

      operation do |settings|
        security { basic_auth settings.api_key, '' }
      end
    end
  end
end

Evil::Client::Middleware::StringifyJson.prepend StringifyJsonPatch

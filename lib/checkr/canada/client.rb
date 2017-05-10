# frozen_string_literal: true

require "evil-client"
require "base64"

require_relative "types"
require_relative "ext/stringify_json_patch"

require_relative "entities/report"
require_relative "entities/candidate"

module Checkr
  module Canada
    # Checkr Canada API client
    class Client < Evil::Client
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

      include Entities::Report::Operations
      include Entities::Candidate::Operations
    end
  end
end

Evil::Client::Middleware::StringifyJson.prepend StringifyJsonPatch

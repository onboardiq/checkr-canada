# frozen_string_literal: true

require "dry-types"

module Checkr
  module Canada
    # Dry types + custom types
    module Types
      include Dry::Types.module

      Status = Types::Strict::String.enum(
        'pending', 'clear', 'consider', 'suspended'
      )

      Gender = Types::Strict::String.enum('M', 'F')
      Email = Types::Strict::String
      Date = Types::Strict::String.constrained(format: /\d{4}\-\d{2}\-\d{2}/)
    end
  end
end

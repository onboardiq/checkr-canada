# frozen_string_literal: true

require "dry-types"

module Checkr
  module Canada
    PROVINCE_CODES = %w[
      AB
      BC
      MB
      NB
      NL
      NT
      NS
      NU
      ON
      PE
      QC
      SK
      YT
    ].freeze

    # Dry types + custom types
    module Types
      include Dry.Types(default: :nominal)

      Status = Strict::String.enum(
        'pending', 'clear', 'consider', 'suspended'
      )

      Package = Strict::String.enum(
        'mvr', 'criminal', 'criminal_mvr'
      )

      DocumentType = Strict::String.enum(
        'identification', 'consent'
      )

      Province = Strict::String.enum(*PROVINCE_CODES)

      Gender = Strict::String.enum('M', 'F')
      Email = Strict::String

      Date = Strict::String
             .constrained(format: /\A\d{4}-\d{2}-\d{2}\z/)
             .constructor do |value|
               begin
                 date = value.to_date if value.respond_to? :to_date
                 date ||= ::Date.parse(value.to_s)
                 date.strftime "%Y-%m-%d"
               rescue
                 raise Dry::Types::ConstraintError.new(
                   "#{value.inspect} cannot be coerced to date",
                   value
                 )
               end
             end
    end
  end
end

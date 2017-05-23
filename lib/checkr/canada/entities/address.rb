# frozen_string_literal: true

module Checkr
  module Canada
    module Entities
      class AddressForm < Evil::Struct
        attribute :street1, Types::Strict::String
        attribute :street2, Types::String, optional: true
        attribute :region, Types::Province
        attribute :city, Types::Strict::String
        attribute :postal_code, Types::Strict::String
        attribute :country, Types::Strict::String, default: proc { "CA" }
        attribute :start_date, Types::Date
      end

      class Address < AddressForm
        attribute :id, Types::Strict::String
        attribute :object, Types::String, optional: true
        attribute :uri, Types::Strict::String
        attribute :created_at, Types::Json::DateTime
        attribute :updated_at, Types::Json::DateTime, optional: true
      end
    end

    class Client
      operation :create_address do |_settings|
        http_method :post

        path { |candidate_id:, **| "candidates/#{candidate_id}/addresses" }

        body format: "json", model: Entities::AddressForm

        response :success, 201, format: :json, model: Entities::Address

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :invalid, 400, format: :json, raise: true do
          attribute :error
        end
      end

      scope :addresses do
        def create(data)
          operations[:create_address].call(data)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Checkr
  module Canada
    module Entities
      class CriminalRecordForm < Evil::Struct
        attribute :offence, Types::Strict::String
        attribute :location, Types::Strict::String
        attribute :sentence_date, Types::Date
      end

      class CriminalRecord < CriminalRecordForm
        attribute :id, Types::Strict::String
        attribute :object, Types::String, optional: true
        attribute :uri, Types::Strict::String
        attribute :created_at, Types::Json::DateTime
        attribute :updated_at, Types::Json::DateTime, optional: true
      end
    end

    class Client
      operation :create_criminal_record do |_settings|
        http_method :post

        path do |candidate_id:, **|
          "candidates/#{candidate_id}/criminal_records"
        end

        body format: "json", model: Entities::CriminalRecordForm

        response :success, 201, format: :json, model: Entities::CriminalRecord

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :invalid, 400, format: :json, raise: true do
          attribute :error
        end
      end

      scope :criminal_records do
        def create(**data)
          operations[:create_criminal_record].call(**data)
        end
      end
    end
  end
end

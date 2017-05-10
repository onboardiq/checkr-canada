# frozen_string_literal: true

module Checkr
  module Canada
    module Entities
      class Document < Evil::Struct
        attribute :id, Types::Strict::String
        attribute :object, Types::String, optional: true
        attribute :filename, Types::String, optional: true
        attribute :uri, Types::Strict::String
        attribute :download_uri, Types::Strict::String
        attribute :created_at, Types::Json::DateTime
        attribute :content_type, Types::String, optional: true
        attribute :filesize, Types::Int, optional: true
      end
    end

    class Client
      operation :upload_document do |_settings|
        http_method :post

        path { |candidate_id:, **| "candidates/#{candidate_id}/documents" }

        body format: "json" do
          attribute :type, Types::DocumentType
          attribute :url, Types::Strict::String
          attribute :filename, Types::Strict::String, optional: true
        end

        response :success, 201, format: :json, model: Entities::Document

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :invalid, 400, format: :json, raise: true do
          attribute :error
        end
      end

      scope :documents do
        def upload(**data)
          operations[:upload_document].call(**data)
        end
      end
    end
  end
end

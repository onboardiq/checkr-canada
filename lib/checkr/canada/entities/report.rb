# frozen_string_literal: true

module Checkr
  module Canada
    module Entities
      class Report < Evil::Struct
        attribute :id, Types::Strict::String
        attribute :object, Types::Strict::String
        attribute :uri, Types::Strict::String
        attribute :package, Types::Package
        attribute :status, Types::Status
        attribute :adjudication, Types::String, optional: true
        attribute :created_at, Types::Json::DateTime
        attribute :completed_at, Types::Json::DateTime
        attribute :turnaround_time, Types::Int, optional: true
        attribute :account_id, Types::Strict::String, optional: true
        attribute :candidate_id, Types::Strict::String, optional: true
        attribute :motor_vehicle_report_id, Types::String, optional: true
        attribute :national_criminal_search_id, Types::String, optional: true
        attribute :criminal_record_ids, Types::Array.member(Types::Strict::String), optional: true
        attribute :document_ids, Types::Array.member(Types::Strict::String), optional: true
      end
    end

    class Client
      operation :list_reports do |_settings|
        http_method :get
        path { "reports" }

        query do
          attributes optional: true do
            attribute :page
            attribute :per_page
          end
        end

        response :success, 200, format: :json do
          attribute :object, Types::Strict::String
          attribute :next_href, Types::String, optional: true
          attribute :previous_href, Types::String, optional: true
          attribute :count, Types::Strict::Int
          attribute :data, Types::Coercible::Array.member(Entities::Report)
        end

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :not_found, 404, format: :json, raise: true do
          attribute :error
        end
      end

      operation :get_report do |_settings|
        http_method :get
        path { |id:, **| "reports/#{id}" }

        response :success, 200, format: :json, model: Entities::Report

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :not_found, 404, format: :json, raise: true do
          attribute :message, as: :error
        end
      end

      operation :create_report do |_settings|
        http_method :post

        path { |candidate_id:, **| "candidates/#{candidate_id}/reports" }

        body format: "json" do
          attribute :package, Types::Package
        end

        response :success, 200, format: :json, model: Entities::Report

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :invalid, 400, format: :json, raise: true do
          attribute :error
        end
      end

      scope :reports do
        def all(**data)
          operations[:list_reports].call(**data)
        end

        def get(id, **data)
          operations[:get_report].call(id: id, **data)
        end

        def create(**data)
          operations[:create_report].call(**data)
        end
      end
    end
  end
end

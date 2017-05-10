# frozen_string_literal: true

module Checkr::Canada
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
      attribute :turnaround_time, Types::Strict::Int, optional: true
      attribute :account_id, Types::Strict::String, optional: true
      attribute :candidate_id, Types::Strict::String, optional: true
      attribute :motor_vehicle_report_id, Types::String, optional: true
      attribute :national_criminal_search_id, Types::String, optional: true
      attribute :criminal_record_ids, Types::Array.member(Types::Strict::String), optional: true
      attribute :document_ids, Types::Array.member(Types::Strict::String), optional: true

      module Operations
        def self.included(base)
          base.operation :list_reports do |_settings|
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
              attribute :data, Types::Coercible::Array.member(Report)
            end

            response :not_authorized, 401, format: :json, raise: true do
              attribute :error
            end

            response :not_found, 404, format: :json, raise: true do
              attribute :error
            end
          end

          base.operation :get_report do |_settings|
            http_method :get
            path { |id:, **| "reports/#{id}" }

            response :success, 200, format: :json, model: Report

            response :not_authorized, 401, format: :json, raise: true do
              attribute :error
            end

            response :not_found, 404, format: :json, raise: true do
              attribute :message, as: :error
            end
          end

          base.operation :create_report do |_settings|
            http_method :post

            path { |candidate_id:, **| "candidates/#{candidate_id}/reports" }

            body format: "json" do
              attribute :package, Types::Package
            end

            response :success, 200, format: :json, model: Report

            response :not_authorized, 401, format: :json, raise: true do
              attribute :error
            end

            response :invalid, 400, format: :json, raise: true do
              attribute :error
            end
          end

          base.scope :reports do
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
  end
end

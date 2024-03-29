# frozen_string_literal: true

module Checkr
  module Canada
    module Entities
      class CandidateForm < Evil::Struct
        attribute :first_name, Types::Strict::String
        attribute :middle_name, Types::String, optional: true
        attribute :last_name, Types::Strict::String
        attribute :mother_maiden_name, Types::String, optional: true

        attribute :email, Types::Email
        attribute :dob, Types::Date
        attribute :phone, Types::Strict::String
        attribute :gender, Types::Gender, optional: true

        attribute :birth_place, Types::String, optional: true
        attribute :birth_country, Types::Strict::String, default: proc { 'CA' }

        attribute :driver_license_province, Types::String, optional: true
        attribute :driver_license_number, Types::String, optional: true

        attribute :nationality, Types::String, optional: true
        attribute :entry_date, Types::String, optional: true

        attribute :custom_id, Types::String, optional: true
      end

      class Candidate < CandidateForm
        attribute :id, Types::Strict::String
        attribute :object, Types::Strict::String
        attribute :uri, Types::Strict::String
        attribute :created_at, Types::JSON::DateTime
        attribute :updated_at, Types::JSON::DateTime, optional: true

        attribute :address_ids, Types::Strict::Array.of(Types::Strict::String)
      end
    end

    class Client
      operation :list_candidates do |_settings|
        http_method :get
        path { "candidates" }

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
          attribute :count, Types::Strict::Integer
          attribute :data, Types::Coercible::Array.of(Entities::Candidate)
        end

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :not_found, 404, format: :json, raise: true do
          attribute :error
        end
      end

      operation :get_candidate do |_settings|
        http_method :get
        path { |id:, **| "candidates/#{id}" }

        response :success, 200, format: :json, model: Entities::Candidate

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end

        response :not_found, 404, format: :json, raise: true do
          attribute :message, as: :error
        end
      end

      operation :create_candidate do |_settings|
        http_method :post

        path { "candidates" }

        body format: "json", model: Entities::CandidateForm

        response :success, 201, format: :json, model: Entities::Candidate

        response :not_authorized, 401, format: :json, raise: true do
          attribute :error
        end
      end

      scope :candidates do
        def all(**data)
          operations[:list_candidates].call(**data)
        end

        def get(id, data = {})
          operations[:get_candidate].call(data.merge(id: id))
        end

        def create(data)
          operations[:create_candidate].call(data)
        end
      end
    end
  end
end

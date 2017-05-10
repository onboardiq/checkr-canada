# frozen_string_literal: true

require "spec_helper"

describe "Authentication" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }
  subject { client.reports.all }

  context "successful" do
    before do
      stub_request(:get, "https://api.checkr.com/ca/v1/reports").to_return(
        body: { data: [], object: "list", count: 0 }.to_json
      )
    end

    it "build basic auth from api_key" do
      subject

      expect(
        a_request(:get, "https://api.checkr.com/ca/v1/reports")
          .with(basic_auth: ["test_api_key", ""])
      ).to have_been_made
    end
  end

  context "failed" do
    before do
      stub_request(:get, "https://api.checkr.com/ca/v1/reports").to_return(
        body: { error: 'Not authorized' }.to_json, status: 401
      )
    end

    it "raises error" do
      expect { subject }.to raise_error(Evil::Client::Operation::ResponseError)

      expect(
        a_request(:get, "https://api.checkr.com/ca/v1/reports")
          .with(basic_auth: ["test_api_key", ""])
      ).to have_been_made
    end
  end
end

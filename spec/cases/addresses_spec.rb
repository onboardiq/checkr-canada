# frozen_string_literal: true

require "spec_helper"

describe "Addresses" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }

  describe "#create" do
    let(:answer) do
      File.read("./spec/fixtures/address.json")
    end

    let(:params) do
      {
        candidate_id: 'abc123xyz',
        street1: "Mission st",
        street2: "4-2",
        region: "BC",
        city: "San Francisco",
        postal_code: "BC341",
        start_date: "2017-01-02"
      }
    end

    subject(:doc) { client.addresses.create(**params) }

    before do
      stub_request(:post, /candidates\/abc123xyz\/addresses/)
        .to_return(
          body: answer,
          status: 201
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:post, "https://api.checkr.com/ca/v1/candidates/abc123xyz/addresses")
      ).to have_been_made
    end

    it "returns an address", :aggregate_failures do
      expect(doc.country).to eq "CA"
      expect(doc.created_at).to be_a(DateTime)
    end

    it "raises when missing params" do
      params.delete(:region)

      expect { subject }.to raise_error(ArgumentError)
    end

    it "raises when unknown region" do
      params[:region] = "Arizona"

      expect { subject }.to raise_error(TypeError)
    end

    it "raises when missing candidate_id" do
      params.delete(:candidate_id)

      expect { subject }.to raise_error(ArgumentError)
    end
  end
end

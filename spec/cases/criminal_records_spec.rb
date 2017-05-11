# frozen_string_literal: true

require "spec_helper"

describe "Criminal Records" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }

  describe "#create" do
    let(:answer) do
      File.read("./spec/fixtures/criminal_record.json")
    end

    let(:params) do
      {
        candidate_id: 'abc123xyz',
        offence: "Pissing in the street",
        sentence_date: Time.new(2001, 3, 21, 14, 0, 0),
        location: "Moscow"
      }
    end

    subject(:doc) { client.criminal_records.create(**params) }

    before do
      stub_request(:post, /candidates\/abc123xyz\/criminal_records/)
        .to_return(
          body: answer,
          status: 201
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:post, "https://api.checkr.com/ca/v1/candidates/abc123xyz/criminal_records")
      ).to have_been_made
    end

    it "returns a record", :aggregate_failures do
      expect(doc.sentence_date).to eq "2001-03-21"
      expect(doc.created_at).to be_a(DateTime)
    end

    it "raises when missing params" do
      params.delete(:offence)

      expect { subject }.to raise_error(ArgumentError)
    end

    it "raises when missing candidate_id" do
      params.delete(:candidate_id)

      expect { subject }.to raise_error(ArgumentError)
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe "Documents" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }

  describe "#upload" do
    let(:answer) do
      File.read("./spec/fixtures/document.json")
    end

    let(:params) do
      {
        candidate_id: 'abc123xyz',
        type: "identification",
        url: "http://example.com/image.png",
        filename: "test.png"
      }
    end

    subject(:doc) { client.documents.upload(**params) }

    before do
      stub_request(:post, /candidates\/abc123xyz\/documents/)
        .to_return(
          body: answer,
          status: 201
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:post, "https://api.checkr.com/ca/v1/candidates/abc123xyz/documents")
      ).to have_been_made
    end

    it "returns a document", :aggregate_failures do
      expect(doc.filename).to eq "test.png"
      expect(doc.created_at).to be_a(DateTime)
    end

    it "raises when missing params" do
      params.delete(:type)

      expect { subject }.to raise_error(ArgumentError)
    end

    it "raises when unknown type" do
      params["type"] = "image"

      expect { subject }.to raise_error(TypeError)
    end

    it "raises when missing candidate_id" do
      params.delete(:candidate_id)

      expect { subject }.to raise_error(ArgumentError)
    end
  end
end

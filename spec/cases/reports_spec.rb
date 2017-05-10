# frozen_string_literal: true

require "spec_helper"

describe "Reports" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }

  describe "#all" do
    let(:answer) { { data: [], object: "list", count: 0 }.to_json }
    let(:options) { {} }

    subject { client.reports.all(**options) }

    before do
      stub_request(:get, /reports/)
        .to_return(
          body: answer
        )
    end

    it "builds response", :aggregate_failures do
      expect(subject.count).to eq 0
      expect(subject.object).to eq 'list'
      expect(subject.next_href).to be_nil
      expect(subject.previous_href).to be_nil
      expect(subject.data.size).to eq 0
    end

    context "with params" do
      let(:options) { { per_page: 1, page: 2, foo: "bar" } }

      it "recognizes only valid params" do
        subject

        expect(
          a_request(:get, "https://api.checkr.com/ca/v1/reports")
          .with(query: { per_page: 1, page: 2 })
        ).to have_been_made
      end
    end

    context "with data" do
      let(:answer) do
        File.read("./spec/fixtures/reports.json")
      end

      it "builds report", :aggregate_failures do
        expect(subject.data.size).to eq 1

        report = subject.data.first

        expect(report.package).to eq "criminal"
        expect(report.created_at).to be_a(DateTime)
        expect(report.created_at.to_date).to eq Date.new(2017, 5, 2)
        expect(report.candidate_id).to eq "7f23225f47ee143389595481"
      end
    end
  end

  describe "#get" do
    let(:answer) do
      File.read("./spec/fixtures/report.json")
    end

    subject(:report) { client.reports.get('123abc') }

    before do
      stub_request(:get, /reports\/123/)
        .to_return(
          body: answer
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:get, "https://api.checkr.com/ca/v1/reports/123abc")
      ).to have_been_made
    end

    it "builds report", :aggregate_failures do
      expect(report.package).to eq "criminal"
      expect(report.created_at).to be_a(DateTime)
      expect(report.created_at.to_date).to eq Date.new(2017, 5, 2)
      expect(report.candidate_id).to eq "7f23225f47ee143389595481"
    end

    context "not found" do
      before do
        stub_request(:get, /reports\/123/)
          .to_return(
            body: { message: 'Not found' }.to_json,
            status: 404
          )
      end

      it "raises error" do
        expect { subject }.to raise_error(Evil::Client::Operation::ResponseError)
      end
    end
  end

  describe "#create" do
    let(:answer) do
      File.read("./spec/fixtures/report.json")
    end

    let(:params) do
      {
        candidate_id: "abc123",
        package: "criminal"
      }
    end

    subject(:report) { client.reports.create(params) }

    before do
      stub_request(:post, /reports/)
        .to_return(
          body: answer
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:post, "https://api.checkr.com/ca/v1/candidates/abc123/reports")
      ).to have_been_made
    end

    it "returns a report", :aggregate_failures do
      expect(report.package).to eq "criminal"
    end

    it "raises when unknown package" do
      params[:package] = "test"

      expect { subject }.to raise_error(Dry::Types::ConstraintError)
    end

    it "raises when missing candidate_id" do
      params.delete(:candidate_id)

      expect { subject }.to raise_error(ArgumentError)
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe "Candidates" do
  let(:client) { Checkr::Canada::Client.new("test_api_key") }

  describe "#all" do
    let(:answer) { { data: [], object: "list", count: 0 }.to_json }
    let(:options) { {} }

    subject { client.candidates.all(**options) }

    before do
      stub_request(:get, /candidates/)
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
          a_request(:get, "https://api.checkr.com/ca/v1/candidates")
          .with(query: { per_page: 1, page: 2 })
        ).to have_been_made
      end
    end

    context "with data" do
      let(:answer) do
        File.read("./spec/fixtures/candidates.json")
      end

      it "builds candidate", :aggregate_failures do
        expect(subject.data.size).to eq 1

        candidate = subject.data.first

        expect(candidate.dob).to eq "1975-03-19"
        expect(candidate.created_at).to be_a(DateTime)
        expect(candidate.created_at.to_date).to eq Date.new(2017, 3, 23)
      end
    end
  end

  describe "#get" do
    let(:answer) do
      File.read("./spec/fixtures/candidate.json")
    end

    subject(:candidate) { client.candidates.get('123abc') }

    before do
      stub_request(:get, /candidates\/123/)
        .to_return(
          body: answer
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:get, "https://api.checkr.com/ca/v1/candidates/123abc")
      ).to have_been_made
    end

    it "builds candidate", :aggregate_failures do
      expect(candidate.dob).to eq "1975-03-19"
      expect(candidate.created_at).to be_a(DateTime)
      expect(candidate.created_at.to_date).to eq Date.new(2017, 3, 23)
    end

    context "not found" do
      before do
        stub_request(:get, /candidates\/123/)
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
      File.read("./spec/fixtures/candidate.json")
    end

    let(:params) do
      {
        first_name: "Test",
        last_name: "Candidate",
        email: "testonboard@test.com",
        phone: "000-000-0002",
        birth_place: "Toronto",
        dob: Date.new(2017, 3, 23),
        gender: "F"
      }
    end

    subject(:candidate) { client.candidates.create(params) }

    before do
      stub_request(:post, /candidates/)
        .to_return(
          body: answer,
          status: 201
        )
    end

    it "makes request" do
      subject

      expect(
        a_request(:post, "https://api.checkr.com/ca/v1/candidates")
      ).to have_been_made
    end

    it "returns a candidate", :aggregate_failures do
      expect(candidate.first_name).to eq "Test"
      expect(candidate.last_name).to eq "Candidate"
    end

    it "raises when missing params" do
      params.delete(:first_name)

      expect { subject }.to raise_error(ArgumentError)
    end
  end
end

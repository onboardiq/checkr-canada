# frozen_string_literal: true

require "spec_helper"

describe Checkr::Canada::Types do
  describe "Status" do
    subject { described_class::Status }

    it "accepts", :aggregate_failures do
      expect(subject["clear"]).to eq "clear"
      expect(subject["pending"]).to eq "pending"
      expect(subject["consider"]).to eq "consider"
      expect(subject["suspended"]).to eq "suspended"
    end

    it "rejects" do
      expect { subject["foobar"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "Date" do
    subject { described_class::Date }

    it "accepts valid string" do
      expect(subject["1989-07-01"]).to eq "1989-07-01"
    end

    it "accepts Date" do
      expect(subject[Date.new(1988, 2, 12)]).to eq "1988-02-12"
    end

    it "accepts Time" do
      expect(subject[Time.new(1990, 12, 31, 12, 0, 0)]).to eq "1990-12-31"
    end

    it "rejects invalid string" do
      expect { subject["today"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "Gender" do
    subject { described_class::Gender }

    it "accepts", :aggregate_failures do
      expect(subject["M"]).to eq "M"
      expect(subject["F"]).to eq "F"
    end

    it "rejects" do
      expect { subject["Any"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "Package" do
    subject { described_class::Package }

    it "accepts", :aggregate_failures do
      expect(subject["mvr"]).to eq "mvr"
      expect(subject["criminal"]).to eq "criminal"
      expect(subject["criminal_mvr"]).to eq "criminal_mvr"
    end

    it "rejects" do
      expect { subject["stupid"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "DocumentType" do
    subject { described_class::DocumentType }

    it "accepts", :aggregate_failures do
      expect(subject["identification"]).to eq "identification"
      expect(subject["consent"]).to eq "consent"
    end

    it "rejects" do
      expect { subject["image"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end

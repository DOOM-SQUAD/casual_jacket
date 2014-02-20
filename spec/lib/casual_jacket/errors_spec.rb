require 'spec_helper'

describe CasualJacket::Errors do

  let(:handle) { "test-import" }
  let(:group)  { "R1934" }

  let(:errors) { CasualJacket::Errors }

  let(:error_message) { "ERROR: #{group} has summoned an ifrit" }

  describe ".list" do

    let(:expected_list) { { group => error_message } }

    before do
      errors.add(handle, group, error_message)
    end

    it "returns all errors as a hash" do
      expect(errors.list(handle)).to eq(expected_list)
    end

  end

  describe ".for_group" do

    before do
      errors.add(handle, group, error_message)
    end

    it "returns errors for a group as a hash" do
      expect(errors.for_group(handle, group)).to eq(error_message)
    end

  end
end

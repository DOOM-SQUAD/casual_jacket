require 'spec_helper'

describe CasualJacket::Operation do

  let(:id)            { '12345' }
  let(:consumer_name) { 'SomeClassWhatDoesStuff' }

  let(:method_name) { :an_example_field }
  let(:value)       { 'an example piece of data' }

  let(:attributes) { { method_name => value } }

  let(:json_hash) do
    {
      'attributes'    => attributes
    }.to_json
  end

  let(:operation) { CasualJacket::Operation.from_json(id, json_hash) }

  describe 'method additions' do

    it 'appropriately fetches value via method_missing' do
      expect(operation.send("value_for_#{method_name}")).to eq(value)
    end

    it 'raises NoMethodError for keys that do not exist' do
      expect { operation.send("value_for_nothing") }.to raise_error(NoMethodError)
    end

    it 'does not clobber regular NoMethodError exceptions' do
      expect { operation.send(:its_gon_explode) }.to raise_error(NoMethodError)
    end

  end

end

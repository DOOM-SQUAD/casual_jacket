require 'spec_helper'

describe CasualJacket::Operation do

  let(:id)         { '12345' }
  let(:attributes) { { method_name => value }.to_json }
  let(:group)      { 'somegroup' }

  let(:redis_hash) do
    {
      'id'         => id,
      'attributes' => attributes,
      'group'      => group
    }
  end

  let(:operation) { CasualJacket::Operation.from_redis(redis_hash) }

  let(:method_name) { :an_example_field }
  let(:value)       { 'an example piece of data' }

  describe 'method additions' do

    it 'appropriately fetches value via method_missing' do
      expect(operation.send("value_for_#{method_name}")).to eq(value)
    end

    it 'does not clobber regular NoMethodError exceptions' do
      expect { operation.send(:its_gon_explode) }.to raise_error(NoMethodError)
    end

    it 'returns nil for keys that do not exist' do
      expect(operation.send("value_for_nothing")).to be_nil
    end

  end

end

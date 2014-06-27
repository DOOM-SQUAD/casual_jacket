require 'spec_helper'

describe CasualJacket do

  let(:group1) { 'SCHWA' }
  let(:group2) { 'FOO' }

  let(:handle)  { 'test-import' }
  let(:headers) { 'Group Code,UPC Code' }
  let(:row1)    { "#{group1},123456" }
  let(:row2)    { "#{group2},654321" }

  let(:csv_string) { "#{headers}\n#{row1}\n#{row2}" }
  let(:csv_file)   { StringIO.new(csv_string) }

  let(:legend) { { 'Group Code' => 'sku', 'UPC Code' => 'upc_code' } }

  let(:group_header) { 'Group Code' }

  let(:expected_attributes1) do
    {
      'sku'      => group1,
      'upc_code' => '123456'
    }
  end

  let(:expected_attributes2) do
    {
      'sku'      => group2,
      'upc_code' => '654321'
    }
  end

  let(:operation_attributes) { operations.map(&:attributes) }
  let(:operation_groups)     { operations.map(&:group) }

  before do
    CasualJacket::Keys.connection.flushall
    CasualJacket.cache_operations(handle, csv_file, legend, group_header)
  end

  describe '.operation_group' do

    context 'querying for the first group' do

      let(:operations) { CasualJacket.operation_group(handle, group1) }

      it 'returns a single element' do
        expect(operations.count).to eq(1)
      end

      it 'returns an element with a matching group' do
        expect(operations.first.group).to eq(group1)
      end

      it 'returns an operation with the expected attributes' do
        expect(operations.first.attributes).to eq(expected_attributes1)
      end

    end

    context 'querying for the second group' do

      let(:operations) { CasualJacket.operation_group(handle, group2) }

      it 'returns a single element' do
        expect(operations.count).to eq(1)
      end

      it 'returns an element with a matching group' do
        expect(operations.first.group).to eq(group2)
      end

      it 'returns an operation with the expected attributes' do
        expect(operations.first.attributes).to eq(expected_attributes2)
      end

    end

  end

  describe '.all_operations' do

    let(:operations) { CasualJacket.all_operations(handle) }

    it 'returns a hash with the correct groups as keys' do
      expect(operations.keys).to match_array([group1, group2])
    end

    it 'has correctly grouped the first operation' do
      expect(operations[group1].first.group).to eq(group1)
    end

    it 'has correctly grouped the second operation' do
      expect(operations[group2].first.group).to eq(group2)
    end

  end

end

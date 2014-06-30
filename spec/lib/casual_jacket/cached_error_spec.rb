require 'spec_helper'

describe CasualJacket::CachedError do

  let(:handle)       { 'some-import' }
  let(:context)      { {"some_field" => "has this error"} }
  let(:group)        { 'ZOGM' }
  let(:operation_id) { '12345' }

  let(:cached_error) { CasualJacket::CachedError.new(handle, context, group, operation_id) }

  describe '.from_redis' do

    let(:json_string) { cached_error.to_hash.to_json }

    let(:error_from_json) { CasualJacket::CachedError.from_redis(handle, json_string) }

    it 'creates a CachedError with the correct handle' do
      expect(error_from_json.handle).to eq(handle)
    end

    it 'creates a CachedError with the correct context' do
      expect(error_from_json.context).to eq(context)
    end

    it 'creates a CachedError with the correct group' do
      expect(error_from_json.group).to eq(group)
    end

    it 'creates a CachedError with the correct operation id' do
      expect(error_from_json.operation_id).to eq(operation_id)
    end

  end

  describe '#to_hash' do

    let(:expected_hash) do
      {
        'context'      => context.to_json,
        'group'        => group,
        'operation_id' => operation_id
      }
    end

    it 'productes the expected hash' do
      expect(cached_error.to_hash).to eq(expected_hash)
    end

  end

end

# "handle:operation:12345" => "{ ZOGM JSON }"
# "handle:operation:67890" => "{ ZOGM JSON }"
# "handle:errors => "[{ ZOGM JSON }, { ZOGM JSON }]"
#
# {
#   operation_id: \"12345\",
#   context:      \"{ ZOGM JSON ACTIVE RECORD ERRORS HASH }\"
# }

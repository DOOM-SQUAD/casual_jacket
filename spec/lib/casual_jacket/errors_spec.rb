require 'spec_helper'

describe CasualJacket::Errors do

  let(:handle)       { 'foo' }
  let(:context)      { { 'zogm' => 'errors' } }
  let(:context_json) { JSON.generate(context) }

  before do
    CasualJacket::Keys.connection.flushall # FIXME
  end

  describe '#list' do

    let(:cached_error) { CasualJacket::CachedError.new(handle, context_json) }

    let(:result) { CasualJacket::Errors.list(handle) }

    before do
      CasualJacket::Errors.add(handle, cached_error)
    end

    it 'returns a list with a single element' do
      expect(result.length).to eq(1)
    end

    it 'has appropriately cached the handle' do
      expect(result.first.handle).to eq(handle)
    end

    it 'has appropriately cached the context' do
      expect(result.first.context).to eq(context)
    end

  end

  describe '#for_group' do

    let(:group0) { 'correct-group' }
    let(:group1) { 'incorrect-group' }

    let(:cached_error0) { CasualJacket::CachedError.new(handle, context_json, group0) }
    let(:cached_error1) { CasualJacket::CachedError.new(handle, context_json, group1) }

    let(:result) { CasualJacket::Errors.for_group(handle, group0) }

    before do
      CasualJacket::Errors.add(handle, cached_error0)
      CasualJacket::Errors.add(handle, cached_error1)
    end

    it 'returns a list with a single element' do
      expect(result.length).to eq(1)
    end

    it 'has appropriately cached the handle' do
      expect(result.first.handle).to eq(handle)
    end

    it 'has appropriately cached the context' do
      expect(result.first.context).to eq(context)
    end

  end

  describe '#clear' do

    let(:cached_error) { CasualJacket::CachedError.new(handle, context_json) }

    let(:result) { CasualJacket::Errors.list(handle) }

    before do
      CasualJacket::Errors.add(handle, cached_error)
      CasualJacket::Errors.clear(handle)
    end

    it 'purges errors from the cache' do
      expect(result).to be_empty
    end

  end

end

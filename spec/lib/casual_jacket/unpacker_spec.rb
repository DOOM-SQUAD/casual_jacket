require 'spec_helper'

describe CasualJacket::Unpacker do

  let(:handle) { 'test_handle' }

  let(:import) { CasualJacket::Unpacker.new(handle) }

  before do
    Redis.new.flushall
  end

  context 'an import already exists in redis' do

    before do
      Redis.new.set("#{handle}-01", {}.to_json)
      Redis.new.set("#{handle}-02", {}.to_json)
      Redis.new.set("errors:#{handle}", ['01'])
    end

    it 'has two operations' do
      expect(import.operations.count).to eq(2)
    end

    it 'has one error' do
      expect(import.failed_operations.count).to eq(1)
    end

  end

end

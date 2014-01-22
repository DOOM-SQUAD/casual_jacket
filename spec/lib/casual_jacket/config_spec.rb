require 'spec_helper'

describe CasualJacket::Config do

  let(:config) { CasualJacket::Config }

  after do
    CasualJacket::Config.reset
  end

  describe 'standard configuration' do

    let(:domain) { 'fake.domain.string' }

    before do
      CasualJacket.configure do |settings|
        settings.redis_host = domain
      end
    end

    it 'correctly applies the value to the desired setting' do
      expect(config.redis_host).to eq(domain)
    end

  end

  describe 'access attempt to undefined setting' do

    let(:expected_error) { CasualJacket::Errors::SettingNotConfigured }

    before do
      CasualJacket::Config.redis_host = nil
    end

    it 'raises a SettingNotConfigured error' do
      expect { config.redis_host }.to raise_error(expected_error)
    end

  end

end

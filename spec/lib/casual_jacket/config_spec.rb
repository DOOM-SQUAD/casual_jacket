require 'spec_helper'

describe CasualJacket::Config do

  let(:config) { CasualJacket::Config }

  let(:domain) { 'fake.domain.string' }

  after do
    CasualJacket::Config.reset
  end

  describe '.load!' do

    let(:domain) { 'redis://some.url.thing:6732' }

    before do
      CasualJacket.load!('./spec/data/config_yaml.yml')
    end

    it 'correctly sets the redis host' do
      expect(config.redis_host).to eq(domain)
    end

  end

  describe 'standard configuration' do

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

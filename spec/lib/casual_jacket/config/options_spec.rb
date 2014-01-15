require 'spec_helper'

describe CasualJacket::Config::Options do

  let(:options) { CasualJacket::Config::Options }

  describe 'method generation' do

    context 'no default value is given' do

      let(:value) { 'value' }

      before do
        options.option :regular_option
        options.regular_option = value
      end

      it 'sets the value' do
        expect(options.regular_option).to eq(value)
      end

    end

    context 'a default value is given' do

      let(:default_value) { 'default_value' }

      before do
        options.option :defaulted_option, default: default_value
      end

      it 'sets the default value' do
        expect(options.defaulted_option).to eq(default_value)
      end

    end

  end

end

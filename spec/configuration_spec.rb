# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SmartHash::Configuration do
  before(:each) do
    SmartHash.configuration = SmartHash::Configuration.new
  end

  after(:each) do
    SmartHash.configuration = SmartHash::Configuration.new
  end

  it 'should have a configuration' do
    expect(SmartHash.configuration).to be_a(SmartHash::Configuration)
  end

  it 'should raise an error when adding an invalid configuration' do
    expect { SmartHash.configuration = 'A BAD CONFIG' }.to raise_error SmartHash::InvalidConfiguration
  end

  context 'settings' do
    context 'enabled' do
      it 'should be disabled' do
        expect(SmartHash.configuration.enabled).to eq(false)
      end

      it 'can be enabled' do
        SmartHash.configure { |c| c.enabled = true }
        expect(SmartHash.configuration.enabled).to eq(true)
      end
    end

    context 'default_format' do
      it 'defaults to :symbol' do
        expect(SmartHash.configuration.default_format).to eq(:symbol)
      end

      context 'validations' do
        it 'can change when valid' do
          SmartHash.configure { |c| c.default_format = :string }
          expect(SmartHash.configuration.default_format).to eq(:string)
        end

        it 'does not change when invalid' do
          SmartHash.configure { |c| c.default_format = :default }
          expect(SmartHash.configuration.default_format).to eq(:symbol)
        end
      end
    end

    context 'smart_by_default' do
      it 'should be disabled' do
        expect(SmartHash.configuration.smart_by_default).to eq(false)
      end

      it 'can be enabled' do
        SmartHash.configure { |c| c.smart_by_default = true }
        expect(SmartHash.configuration.smart_by_default).to eq(true)
      end
    end
  end
end

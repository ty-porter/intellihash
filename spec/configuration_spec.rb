# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Intellihash::Configuration do
  before(:each) do
    Intellihash.configuration = Intellihash::Configuration.new
  end

  after(:each) do
    Intellihash.configuration = Intellihash::Configuration.new
  end

  it 'should have a configuration' do
    expect(Intellihash.configuration).to be_a(Intellihash::Configuration)
  end

  it 'should raise an error when adding an invalid configuration' do
    expect { Intellihash.configuration = 'A BAD CONFIG' }.to raise_error Intellihash::InvalidConfiguration
  end

  context 'settings' do
    context 'enabled' do
      it 'should be disabled' do
        expect(Intellihash.configuration.enabled).to eq(false)
      end

      it 'can be enabled' do
        Intellihash.configure { |c| c.enabled = true }
        expect(Intellihash.configuration.enabled).to eq(true)
      end
    end

    context 'default_format' do
      it 'defaults to :symbol' do
        expect(Intellihash.configuration.default_format).to eq(:symbol)
      end

      context 'validations' do
        it 'can change when valid' do
          Intellihash.configure { |c| c.default_format = :string }
          expect(Intellihash.configuration.default_format).to eq(:string)
        end

        it 'does not change when invalid' do
          Intellihash.configure { |c| c.default_format = :default }
          expect(Intellihash.configuration.default_format).to eq(:symbol)
        end
      end
    end

    context 'smart_by_default' do
      it 'should be disabled' do
        expect(Intellihash.configuration.smart_by_default).to eq(false)
      end

      it 'can be enabled' do
        Intellihash.configure { |c| c.smart_by_default = true }
        expect(Intellihash.configuration.smart_by_default).to eq(true)
      end
    end
  end
end

# frozen_string_literal: true

# Requires 2 things:
#
# :hash:  -> Original hash
# :hash2: -> Return value of a method, i.e. { foo: :bar }.merge(baz: :bat)
RSpec.shared_examples 'intelligent hash attribute' do
  context 'when creating a new hash from a intelligent hash' do
    before { hash.is_intelligent = true }

    it 'is also intelligent' do
      expect(hash.is_intelligent?).to eq(true)
      expect(hash2.is_intelligent?).to eq(true)
    end
  end

  context 'when creating a new hash from a non-intelligent hash' do
    it 'is not intelligent' do
      expect(hash.is_intelligent?).to eq(false)
      expect(hash2.is_intelligent?).to eq(false)
    end
  end

  context 'with overridden configuration' do
    before do
      Intellihash.configure do |config|
        config.enabled                = true
        config.intelligent_by_default = true
      end
    end

    after do
      Intellihash.configure do |config|
        config.enabled                = true
        config.intelligent_by_default = false
      end
    end

    it 'ignores intelligent_by_default' do
      hash.is_intelligent = false

      expect(hash.is_intelligent?).to eq(false)
      expect(hash2.is_intelligent?).to eq(false)
    end
  end

  context 'expected value' do
    it 'is returned correctly' do
      expect(hash2).to eq(expected)
    end
  end
end

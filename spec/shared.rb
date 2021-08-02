# frozen_string_literal: true

# Requires 2 things:
#
# :hash:  -> Original hash
# :hash2: -> Return value of a method, i.e. { foo: :bar }.merge(baz: :bat)
RSpec.shared_examples 'smart hash attribute' do
  context 'when creating a new hash from a smart hash' do
    before { hash.is_smart = true }

    it 'is also smart' do
      expect(hash.is_smart?).to eq(true)
      expect(hash2.is_smart?).to eq(true)
    end
  end

  context 'when creating a new hash from a non-smart hash' do
    it 'is not smart' do
      expect(hash.is_smart?).to eq(false)
      expect(hash2.is_smart?).to eq(false)
    end
  end

  context 'with overridden configuration' do
    before do
      Intellihash.configure do |config|
        config.enabled          = true
        config.smart_by_default = true
      end
    end

    after do
      Intellihash.configure do |config|
        config.enabled          = true
        config.smart_by_default = false
      end
    end

    it 'ignores smart_by_default' do
      hash.is_smart = false

      expect(hash.is_smart?).to eq(false)
      expect(hash2.is_smart?).to eq(false)
    end
  end

  context 'expected value' do
    it 'is returned correctly' do
      expect(hash2).to eq(expected)
    end
  end
end

# frozen_string_literal: true

require_relative 'shared'

RSpec.describe Intellihash do
  before do
    Intellihash.configure do |config|
      config.enabled = true
    end
  end

  after { Intellihash.configuration = Intellihash::Configuration.new }

  it 'has a version number' do
    expect(Intellihash::VERSION).not_to be nil
  end

  context 'extends Hash class' do
    it 'is included in Hash' do
      expect(Hash.included_modules).to include(Intellihash::Mixins)
      expect(Hash.included_modules).to include(Intellihash::Callbacks)
    end
  end

  let(:empty_hash) { {} }
  let(:flat_hash) { { foo: :bar } }
  let(:nested_hash) { { foo: { bar: :baz } } }

  context 'when is a intelligent hash' do
    before { allow_any_instance_of(Hash).to receive(:is_intelligent?).and_return true }

    context 'attr_readers' do
      it 'returns nil if key is not in hash' do
        expect(empty_hash.foo).to eq(nil)
      end

      it 'returns the value in the hash if key is in hash' do
        expect(flat_hash.foo).to eq(:bar)
      end

      it 'returns nested values' do
        expect(nested_hash.foo.bar).to eq(:baz)
      end

      context 'with :from parameter' do
        let(:hash) do
          {
            foo: :bar,
            'baz' => 'bat'
          }
        end

        context 'string' do
          it 'returns the value of string key in hash' do
            expect(hash.baz(from: :string)).to eq('bat')
          end

          it 'does not return value of symbol key in hash' do
            expect(hash.foo(from: :string)).to be_nil
          end
        end

        context 'symbol' do
          it 'returns the value of symbol key in hash' do
            expect(hash.foo(from: :symbol)).to eq(:bar)
          end

          it 'does not return value of symbol key in hash' do
            expect(hash.baz(from: :symbol)).to be_nil
          end
        end
      end
    end

    context 'attr_writers' do
      it 'updates value if key is not in hash' do
        empty_hash.foo = :bar
        expect(empty_hash.foo).to eq(:bar)
      end

      it 'updates value if key is in hash' do
        flat_hash.foo = :baz
        expect(flat_hash.foo).to eq(:baz)
      end

      it 'updates nested values' do
        nested_hash.foo.bar = :qux
        expect(nested_hash.foo.bar).to eq(:qux)
      end
    end

    context 'default format' do
      let(:hash) { { foo: :bar } }

      context 'is :string' do
        before do
          hash.transform_keys!(&:to_s)
          hash.default_format = :string
        end

        it 'returns the value in hash' do
          expect(hash.foo).to eq(:bar)
        end

        it 'returns nil for symbols' do
          expect(hash.foo(from: :symbol)).to be_nil
        end

        it 'stores as string' do
          hash.bar = :baz
          expect(hash['bar']).to eq(:baz)
          expect(hash[:bar]).to be_nil
        end
      end

      context 'is :symbol' do
        before { hash.default_format = :symbol }

        it 'returns the value in hash' do
          expect(hash.foo).to eq(:bar)
        end

        it 'returns nil for strings' do
          expect(hash.foo(from: :string)).to be_nil
        end

        it 'stores as symbol' do
          hash.bar = :baz
          expect(hash[:bar]).to eq(:baz)
          expect(hash['bar']).to be_nil
        end
      end

      context 'is :any' do
        let(:hash) do
          {
            foo: :bar,
            'bar' => 'baz'
          }
        end

        before { hash.default_format = :any }

        it 'returns the value in hash for symbols' do
          expect(hash.foo).to eq(:bar)
        end

        it 'returns the value in hash for strings' do
          expect(hash.bar).to eq('baz')
        end

        context 'keys with same name, different types' do
          let(:hash) do
            {
              foo: :bar,
              'foo' => 'bar'
            }
          end

          it 'defaults to symbol keys' do
            expect(hash.foo).to eq(:bar)
          end

          it 'can be specified for string keys' do
            expect(hash.foo(from: :string)).to eq('bar')
          end
        end

        it 'stores as symbol by default' do
          hash.bar = :baz
          expect(hash[:bar]).to eq(:baz)
          expect(hash['bar']).to eq('baz')
        end

        it 'can store as a string' do
          hash.store('bar', 'qux')

          expect(hash[:bar]).to be_nil
          expect(hash['bar']).to eq('qux')
        end
      end

      context 'not set' do
        it 'uses symbols' do
          expect(hash.default_format).to eq(:symbol)
        end
      end
    end
  end

  context 'when is not intelligent' do
    context 'attr_readers' do
      it 'raise NoMethodError' do
        expect { empty_hash.foo }.to raise_error NoMethodError
      end
    end

    context 'attr_writers' do
      it 'raise NoMethodError' do
        expect { empty_hash.foo = :bar }.to raise_error NoMethodError
      end
    end
  end

  context 'intelligent inheritance' do
    let(:hash) { { foo: :bar } }

    context '#compact' do
      let(:hash) do
        {
          foo: :bar,
          baz: nil
        }
      end
      let(:hash2) { hash.compact }
      let(:expected) { { foo: :bar } }

      include_examples 'intelligent hash attribute'
    end

    context '#invert' do
      let(:hash2) { hash.invert }
      let(:expected) { { bar: :foo } }

      include_examples 'intelligent hash attribute'
    end

    context '#merge' do
      let(:hash2) { hash.merge(baz: :bat) }
      let(:expected) do
        {
          foo: :bar,
          baz: :bat
        }
      end

      include_examples 'intelligent hash attribute'
    end

    context '#reject' do
      let(:hash2) { hash.reject { |_k, _v| true } }
      let(:expected) { {} }

      include_examples 'intelligent hash attribute'
    end

    context '#select' do
      let(:hash2) { hash.select { |_k, _v| true } }
      let(:expected) { hash }

      include_examples 'intelligent hash attribute'
    end

    context '#slice' do
      let(:hash2) { hash.slice(:foo) }
      let(:expected) { hash }

      include_examples 'intelligent hash attribute'
    end

    context '#to_h' do
      let(:hash2) { hash.to_h }
      let(:expected) { hash }

      include_examples 'intelligent hash attribute'
    end

    context '#transform_keys' do
      let(:hash2) { hash.transform_keys(&:to_s) }
      let(:expected) { { 'foo' => :bar } }

      include_examples 'intelligent hash attribute'
    end

    context '#transform_values' do
      let(:hash2) { hash.transform_values(&:to_s) }
      let(:expected) { { foo: 'bar' } }

      include_examples 'intelligent hash attribute'
    end
  end

  context 'modification in place' do
    let(:hash) { { foo: :bar } }

    before do
      hash.is_intelligent = true
      hash.merge!(baz: :bat)
    end

    it 'does not alter intelligent attribute' do
      expect(hash.is_intelligent?).to eq(true)
      expect(hash).to eq({
                           foo: :bar,
                           baz: :bat
                         })
    end
  end

  context 'equality' do
    let(:hash)  { { foo: :bar } }
    let(:hash2) { { foo: :bar } }

    it 'is equal even if the intelligent attribute differs' do
      expect(hash2 == hash).to eq(true)

      hash2.is_intelligent = true

      expect(hash2 == hash).to eq(true)
    end
  end

  context 'frozen' do
    # rubocop:disable Lint/ConstantDefinitionInBlock
    ATTR_WRITER_METHODS = Intellihash::Mixins.instance_methods.select { |name| name[-1] == '=' } << :to_intellihash
    ATTR_READER_METHODS = Intellihash::Mixins.instance_methods - ATTR_WRITER_METHODS
    # rubocop:enable Lint/ConstantDefinitionInBlock

    let(:hash) { { foo: :bar }.freeze }

    context 'attr_readers' do
      ATTR_READER_METHODS.each do |name|
        context "##{name}" do
          it 'does not raise error' do
            expect { hash.send(name) }.not_to raise_error
          end
        end
      end

      context 'values' do
        context '#intelligent' do
          it 'is never nil' do
            expect(hash.intelligent).not_to be_nil
          end

          it 'returns configured value' do
            expect(hash.intelligent).to eq(Intellihash.configuration.intelligent_by_default)
          end
        end

        context '#default_format' do
          it 'is never nil' do
            expect(hash.default_format).not_to be_nil
          end

          it 'returns configured value' do
            expect(hash.default_format).to eq(Intellihash.configuration.default_format)
          end
        end
      end
    end

    context 'attr_writers' do
      let!(:hash_copy) { hash.dup }

      ATTR_WRITER_METHODS.each do |name|
        context "##{name}" do
          it 'raises error' do
            if name[-1] == '='
              expect { hash.send(name, false) }.to raise_error FrozenError
            else
              expect { hash.send(name) }.to raise_error FrozenError
            end
          end
        end
      end
    end
  end
end

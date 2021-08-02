# frozen_string_literal: true

require 'benchmark'
require 'json'

RSpec.describe 'benchmarks' do
  let(:fixture_path) { './spec/fixtures/sample.json' }
  let(:raw_fixture) { File.read(fixture_path) }

  before(:all) { GC.disable }
  after(:all) { GC.enable }

  before do
    Intellihash.configure do |config|
      config.enabled          = true
      config.smart_by_default = true
      config.default_format   = :string
    end
  end

  context 'Intellihash vs. OpenStruct' do
    it 'is faster', performance: true do
      ostruct_benchmark = Benchmark.measure do
        200.times { JSON.parse(raw_fixture, { object_class: OpenStruct }) }
      end

      shash_benchmark = Benchmark.measure do
        200.times { JSON.parse(raw_fixture).to_intellihash }
      end

      puts "OpenStruct: #{ostruct_benchmark}"
      puts "Intellihash:  #{shash_benchmark}"

      expect(ostruct_benchmark.real > shash_benchmark.real).to eq(true)
    end

    let(:open_struct) { JSON.parse(raw_fixture, { object_class: OpenStruct }) }
    let(:intellihash) { JSON.parse(raw_fixture).to_intellihash }

    it 'behaves similarly' do
      expect(open_struct.apis[0].Description).to eq(intellihash.apis[0].Description)
    end
  end
end

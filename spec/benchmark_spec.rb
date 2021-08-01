# frozen_string_literal: true

require 'benchmark'
require 'json'

RSpec.describe 'benchmarks', performance: true do
  let(:fixture_path) { './spec/fixtures/sample.json' }
  let(:raw_fixture) { File.read(fixture_path) }

  before(:all) { GC.disable }
  after(:all) { GC.enable }

  context 'SmartHash vs. OpenStruct' do
    it 'is faster' do
      ostruct_benchmark = Benchmark.measure do
        200.times { JSON.parse(raw_fixture, { object_class: OpenStruct }) }
      end

      shash_benchmark = Benchmark.measure do
        200.times { JSON.parse(raw_fixture).to_smart_hash }
      end

      puts "OpenStruct: #{ostruct_benchmark}"
      puts "SmartHash:  #{shash_benchmark}"

      expect(ostruct_benchmark.real > shash_benchmark.real).to eq(true)
    end
  end
end

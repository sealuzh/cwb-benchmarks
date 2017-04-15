require_relative '../files/default/sysbench_memory'

RSpec.describe 'SysbenchMemory' do
  let(:bm) { SysbenchMemory.new }
  let(:sample1) { File.read('sysbench_memory_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('0.6827s')
  end

  it 'extracts the average throughput from the result' do
    expect(bm.extract_throughput(sample1)).to eq('1499.93 MB/sec')
  end
end

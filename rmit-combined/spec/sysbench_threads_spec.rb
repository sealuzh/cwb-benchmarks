require_relative '../files/default/sysbench_threads'

RSpec.describe 'SysbenchThreads' do
  let(:bm) { SysbenchThreads.new }
  let(:sample1) { File.read('sysbench_threads_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('15.1658s')
  end

  it 'extracts the average latency result' do
    expect(bm.extract_latency(sample1)).to eq('193.47ms')
  end
end

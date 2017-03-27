require_relative '../files/default/sysbench_threads'

RSpec.describe 'SysbenchThreads' do
  let(:sysbench) { SysbenchThreads.new }
  let(:sample_result) { File.read('sysbench_threads_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('15.1658s')
  end

  it 'extracts the average latency result' do
    expect(sysbench.extract_latency(sample_result)).to eq('193.47ms')
  end
end

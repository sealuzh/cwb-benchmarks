require_relative '../files/default/sysbench_fileio'

RSpec.describe 'SysbenchFileio' do
  let(:bm) { SysbenchFileio.new }
  let(:sample1) { File.read('sysbench_fileio_stdout1.txt') }
  let(:sample2) { File.read('sysbench_fileio_stdout2.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('35.0365s')
    expect(bm.extract_duration(sample2)).to eq('48.6897s')
  end

  it 'extracts the throughput result' do
    expect(bm.extract_throughput(sample1)).to eq('58.453Mb/sec')
    expect(bm.extract_throughput(sample2)).to eq('821.53Kb/sec')
  end

  it 'extracts the average latency result' do
    expect(bm.extract_latency(sample1)).to eq('16.19ms')
    expect(bm.extract_latency(sample2)).to eq('0.02ms')
  end

  it 'extracts the 95 percentile latency result' do
    expect(bm.extract_latency_percentile(sample1)).to eq('24.01ms')
    expect(bm.extract_latency_percentile(sample2)).to eq('0.03ms')
  end
end

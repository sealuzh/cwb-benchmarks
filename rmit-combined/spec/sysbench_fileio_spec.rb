require_relative '../files/default/sysbench_fileio'

RSpec.describe 'SysbenchFileio' do
  let(:sysbench) { SysbenchFileio.new }
  let(:sample_result) { File.read('sysbench_fileio_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('35.0365s')
  end

  it 'extracts the throughput result' do
    expect(sysbench.extract_throughput(sample_result)).to eq('58.453Mb/sec')
  end

  it 'extracts the average latency result' do
    expect(sysbench.extract_latency(sample_result)).to eq('16.19ms')
  end

  it 'extracts the 95 percentile latency result' do
    expect(sysbench.extract_latency_percentile(sample_result)).to eq('24.01ms')
  end
end

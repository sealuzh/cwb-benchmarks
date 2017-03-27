require_relative '../files/default/sysbench_mutex'

RSpec.describe 'SysbenchMutex' do
  let(:sysbench) { SysbenchMutex.new }
  let(:sample_result) { File.read('sysbench_mutex_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('2.3840s')
  end

  it 'extracts the average latency result' do
    expect(sysbench.extract_latency(sample_result)).to eq('2383.86ms')
  end
end

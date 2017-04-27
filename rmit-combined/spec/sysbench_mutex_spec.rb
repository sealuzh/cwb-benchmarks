require_relative '../files/default/sysbench_mutex'

RSpec.describe 'SysbenchMutex' do
  let(:bm) { SysbenchMutex.new }
  let(:sample1) { File.read('sysbench_mutex_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('2.3840s')
  end

  it 'extracts the average latency result' do
    expect(bm.extract_latency(sample1)).to eq('2383.86ms')
  end
end

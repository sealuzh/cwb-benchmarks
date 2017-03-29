require_relative '../files/default/stressng_network'

RSpec.describe 'StressngNetwork' do
  let(:sysbench) { StressngNetwork.new }
  let(:sample_result) { File.read('stressng_network_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('40.01s')
  end

  it 'extracts the epoll bogo ops / s from the result' do
    expect(sysbench.extract_bogo_ops(sample_result, 'epoll')).to eq('68586.14')
  end

  it 'extracts the icmp-flood bogo ops / s from the result' do
    expect(sysbench.extract_bogo_ops(sample_result, 'icmp-flood')).to eq('404121.26')
  end
end

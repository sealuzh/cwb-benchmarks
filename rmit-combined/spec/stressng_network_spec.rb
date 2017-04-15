require_relative '../files/default/stressng_network'

RSpec.describe 'StressngNetwork' do
  let(:bm) { StressngNetwork.new }
  let(:sample1) { File.read('stressng_network_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('40.01s')
  end

  it 'extracts the epoll bogo ops / s from the result' do
    expect(bm.extract_bogo_ops(sample1, 'epoll')).to eq('68586.14')
  end

  it 'extracts the icmp-flood bogo ops / s from the result' do
    expect(bm.extract_bogo_ops(sample1, 'icmp-flood')).to eq('404121.26')
  end
end

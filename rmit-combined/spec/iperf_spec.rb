require_relative '../files/default/iperf_client'

RSpec.describe 'IperfClient' do
  let(:bm) { IperfClient.new }
  let(:sample1) { File.read('iperf_stdout1.txt') }
  let(:sample2) { File.read('iperf_stdout2.txt') }

  it '[single-thread] extracts the average bandwidth from the result' do
    expect(bm.extract_bandwidth(sample1)).to eq('43.4 Gbits/sec')
  end

  it '[multi-thread] extracts the average bandwidth from the result' do
    expect(bm.extract_bandwidth(sample2)).to eq('44.9 Gbits/sec')
  end
end

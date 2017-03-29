require_relative '../files/default/iperf_client'

RSpec.describe 'IperfClient' do
  let(:sysbench) { IperfClient.new }
  let(:sample1) { File.read('iperf_stdout1.txt') }
  let(:sample2) { File.read('iperf_stdout2.txt') }

  it '[single-thread] extracts the average bandwidth from the result' do
    expect(sysbench.extract(sample1)).to eq('43.4 Gbits/sec')
  end

  it '[multi-thread] extracts the average bandwidth from the result' do
    expect(sysbench.extract(sample2)).to eq('44.9 Gbits/sec')
  end
end

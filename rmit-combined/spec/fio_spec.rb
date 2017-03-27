require_relative '../files/default/fio'

RSpec.describe 'Fio' do
  let(:sysbench) { Fio.new }
  let(:sample1) { File.read('fio_stdout1.txt') }
  let(:sample2) { File.read('fio_stdout2.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample1)).to eq('207517msec')
    expect(sysbench.extract(sample2)).to eq('60002msec')
  end

  it 'extracts the throughput result' do
    expect(sysbench.extract_throughput(sample1)).to eq('5052.1KB/s')
    expect(sysbench.extract_throughput(sample2)).to eq('4239.2KB/s')
  end

  it 'extracts the iops result' do
    expect(sysbench.extract_iops(sample1)).to eq('1263')
    expect(sysbench.extract_iops(sample2)).to eq('529')
  end

  it 'extracts the average latency result' do
    expect(sysbench.extract_latency(sample1)).to eq('789.33')
    expect(sysbench.extract_latency(sample2)).to eq('1884.49')
  end

  it 'extracts the 95 percentile latency (clat) result' do
    expect(sysbench.extract_latency_percentile(sample1)).to eq('844')
    expect(sysbench.extract_latency_percentile(sample2)).to eq('8096')
  end

  it 'extracts the disk utilization result' do
    expect(sysbench.extract_disk_util(sample1)).to eq('99.38%')
    expect(sysbench.extract_disk_util(sample2)).to eq('99.68%')
  end
end

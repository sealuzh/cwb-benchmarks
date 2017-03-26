require_relative '../files/default/sysbench_memory'

RSpec.describe 'SysbenchMemory' do
  let(:sysbench) { SysbenchMemory.new }
  let(:sample_result) { File.read('sysbench_memory_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('1499.93 MB/sec')
  end
end

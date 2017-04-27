require_relative '../files/default/sysbench_cpu'

RSpec.describe 'SysbenchCpu' do
  let(:bm) { SysbenchCpu.new }
  let(:sample1) { File.read('sysbench_cpu_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('30.0719s')
  end
end

require_relative '../files/default/sysbench_cpu'

RSpec.describe 'SysbenchCpu' do
  let(:sysbench) { SysbenchCpu.new }
  let(:sample_result) { File.read('sysbench_cpu_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('30.0719s')
  end
end

require_relative '../files/default/stressng_cpu'

RSpec.describe 'StressngCpu' do
  let(:sysbench) { StressngCpu.new }
  let(:sample_result) { File.read('stressng_cpu_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(sysbench.extract(sample_result)).to eq('10.00s')
  end

  it 'extracts the bogo ops / s from the result' do
    expect(sysbench.extract_bogo_ops(sample_result)).to eq('187.50')
  end
end

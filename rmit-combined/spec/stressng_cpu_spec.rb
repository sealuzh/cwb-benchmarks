require_relative '../files/default/stressng_cpu'

RSpec.describe 'StressngCpu' do
  let(:bm) { StressngCpu.new }
  let(:sample1) { File.read('stressng_cpu_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract_duration(sample1)).to eq('10.00s')
  end

  it 'extracts the bogo ops / s from the result' do
    expect(bm.extract_bogo_ops(sample1)).to eq('187.50')
  end
end

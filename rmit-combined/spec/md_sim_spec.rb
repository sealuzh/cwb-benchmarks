require_relative '../files/default/md_sim'

RSpec.describe 'MdSim' do
  let(:bm) { MdSim.new }
  let(:sample_result) { File.read('md_sim_stdout.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract(sample_result)).to eq('242.655382 seconds')
  end
end

require_relative '../files/default/md_sim'

RSpec.describe 'MdSim' do
  let(:bm) { MdSim.new }
  let(:sample1) { File.read('md_sim_stdout1.txt') }

  it 'extracts the total time from the result' do
    expect(bm.extract(sample1)).to eq('242.655382 seconds')
  end
end

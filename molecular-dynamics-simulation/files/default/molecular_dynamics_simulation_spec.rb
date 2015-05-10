require_relative 'molecular_dynamics_simulation'

RSpec.describe 'MolecularDynamicsSimulation' do
  let(:simulation) { MolecularDynamicsSimulation.new }
  let(:sample_result) { File.read('stdout.txt') }

  it 'extracts the total time from the result' do
    expect(simulation.extract_time(sample_result)).to eq('15.738353')
  end
end

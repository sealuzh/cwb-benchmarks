require 'serverspec'

# Required by serverspec
set :backend, :exec


describe 'cwb::default' do
  let(:base_dir) { '/usr/local/cloud-benchmark' }

  it 'should create the base directory' do
    expect(file(base_dir)).to be_directory
  end

  describe 'node.yml config file' do
    subject { file(File.join(base_dir, 'node.yml')) }
    it { should be_file }
    its(:content) { should match /base_dir/ }
  end
end

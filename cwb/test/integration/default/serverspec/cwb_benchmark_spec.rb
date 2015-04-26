require 'serverspec'

# Required by serverspec
set :backend, :exec


describe 'cwb_benchmark' do
  let(:base_dir) { '/usr/local/cloud-benchmark' }
  let(:benchmarks_file) { File.join(base_dir, 'benchmarks.txt') }

  context 'demobench-test' do
    let(:demobench_test_file) { File.join(base_dir, 'demobench-test', 'demobench_test.rb') }
    describe 'implementation file' do
      subject { file(demobench_test_file) }
      it { should be_file }
      its(:content) { should match /class DemobenchTest < Cwb::Benchmark/ }
    end

    describe 'benchmarks file' do
      subject { file(benchmarks_file) }
      it { should be_file }
      its(:content) { should match /demobench-test/ }
    end
  end

  context 'sysbench-test' do
    let(:sysbench_test_file) { File.join(base_dir, 'sysbench-test', 'sysbench_test.rb') }
    describe 'implementation file' do
      subject { file(sysbench_test_file) }
      it { should be_file }
      its(:content) { should match /class SysbenchTest < Cwb::Benchmark/ }
    end

    describe 'benchmarks file' do
      subject { file(benchmarks_file) }
      it { should be_file }
      its(:content) { should match /sysbench-test/ }
    end
  end
end

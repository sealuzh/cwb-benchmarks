require_relative 'sysbench'

RSpec.describe "Sysbench" do
  let(:sysbench) { Sysbench.new }
  let(:sample_result) { File.read('sysbench-stdout.txt') }

  it "extracts the total time from the result" do
    expect(sysbench.extract_time(sample_result)).to eq('10.1301')
  end
end

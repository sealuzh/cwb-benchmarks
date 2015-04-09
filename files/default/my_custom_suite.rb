require "cwb"

class MyCustomSuite < Cwb::BenchmarkSuite
  def execute_suite(cwb_benchmarks)
    my_list = get_list([Sysbench, Sysbench], cwb_benchmarks)
    execute_all(my_list)
    @cwb.notify_finished_execution
  end
end

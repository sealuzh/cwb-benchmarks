require 'cwb'
require 'open3'

# Based on the Molecular Dynamics Simulation case study in:
# Cloud Benchmarking For Maximising Performance of Scientific Applications
# B. Varghese and O. Akgun and I. Miguel and L. Thai and A. Barker
# 6.1.2 Case Study 2: Molecular Dynamic Simulation
class MdSim < Cwb::Benchmark
  def execute
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[md-sim] #{stderr}" unless status.success?
    @cwb.submit_metric("md-sim", timestamp, extract(stdout))
  end

  def cmd
    "./md_sim #{np} #{step_num}"
  end

  def timestamp
    Time.now.to_i
  end

  # Varghese et. al. use 10_000 but that might take ~5h to complete
  def np
    1_000
  end

  def step_num
    200
  end

  def extract(string)
    string[/  ((\d*[.])?\d+ seconds).\n/, 1]
  end
end

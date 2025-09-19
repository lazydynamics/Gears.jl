using EnvironmentEngine
import EnvironmentEngine: Ticker, advance_to!, progress!, can_tick, consume_tick!, reset!
import EnvironmentEngine: TimedJob, EventJob, AsapJob
using BenchmarkTools

"""
Main benchmark suite for EnvironmentEngine.
This file loads all individual benchmark modules and combines them into a single suite.
"""

const SUITE = BenchmarkGroup()

include("core/ticker.jl")
include("core/clocks.jl")
include("jobs/job_creation.jl")
include("jobs/job_progress.jl")
include("schedulers/ticked_scheduler.jl")
include("schedulers/threading.jl")
include("stress/high_frequency.jl")
include("stress/many_jobs.jl")
include("integration/realistic_scenarios.jl")

SUITE["core"] = BenchmarkGroup()
SUITE["core"]["ticker"] = benchmark_ticker()
SUITE["core"]["clocks"] = benchmark_clocks()

SUITE["jobs"] = BenchmarkGroup()
SUITE["jobs"]["creation"] = benchmark_job_creation()
SUITE["jobs"]["progress"] = benchmark_job_progress()

SUITE["schedulers"] = BenchmarkGroup()
SUITE["schedulers"]["ticked"] = benchmark_ticked_scheduler()
SUITE["schedulers"]["threading"] = benchmark_threading()

SUITE["stress"] = BenchmarkGroup()
SUITE["stress"]["high_frequency"] = benchmark_high_frequency()
SUITE["stress"]["many_jobs"] = benchmark_many_jobs()

SUITE["integration"] = BenchmarkGroup()
SUITE["integration"]["realistic_scenarios"] = benchmark_realistic_scenarios()
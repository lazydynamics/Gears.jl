@testitem "Integration test, simple example" begin
    import EnvironmentEngine: VirtualClock, TickedScheduler, advance_time!, every, asap, now, MachineClock
    import Base.Threads: Atomic, atomic_add!

    # Test state tracking structure
    mutable struct TestState
        timed_20ms_count::Atomic{Int}
        timed_30ms_count::Atomic{Int}
        asap_count::Atomic{Int}
        channel_job_count::Atomic{Int}
        observations_received::Vector{Int}
        execution_events::Vector{Tuple{Symbol, Any}}  # (job_type, timestamp)
        lock::ReentrantLock
    end

    TestState() = TestState(
        Atomic{Int}(0), Atomic{Int}(0), Atomic{Int}(0), Atomic{Int}(0), Int[], Tuple{Symbol, Any}[], ReentrantLock()
    )

    function schedule_jobs(scheduler, observations, test_state)
        # Register jobs with proper state tracking
        every(scheduler, 20ms) do dt
            atomic_add!(test_state.timed_20ms_count, 1)
            push!(observations, 1)
        end

        every(scheduler, 30ms) do dt
            atomic_add!(test_state.timed_30ms_count, 1)
        end

        every(scheduler, asap) do
            atomic_add!(test_state.asap_count, 1)
        end

        every(scheduler, observations) do obs
            atomic_add!(test_state.channel_job_count, 1)
            lock(test_state.lock) do
                push!(test_state.observations_received, obs)
            end
        end
    end
    @testset "VirtualClock, TickedScheduler" begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 10ms)

        # Set up global state for testing
        test_state = TestState()
        observations = Channel{Int}(Inf)
        schedule_jobs(scheduler, observations, test_state)

        # Advance time and verify initial state
        advance_time!(clock, 50ms)
        @test test_state.timed_20ms_count[] == 0
        @test test_state.timed_30ms_count[] == 0
        @test test_state.asap_count[] == 0
        @test test_state.channel_job_count[] == 0

        # Update scheduler to process jobs
        update!(scheduler)

        # Verify job execution counts
        @test test_state.timed_20ms_count[] == 2  # Should fire at 20ms and 40ms
        @test test_state.timed_30ms_count[] == 1  # Should fire at 30ms
        @test test_state.asap_count[] == 5       # Should fire at every tick
        @test test_state.channel_job_count[] == 2 # Should process 2 observations

        # Verify observations were received correctly
        @test length(test_state.observations_received) == 2
        @test all(obs == 1 for obs in test_state.observations_received)
    end

    @testset "MachineClock, TickedScheduler" begin
        # Set up global state for testing
        test_state = TestState()
        observations = Channel{Int}(Inf)
        clock = MachineClock()
        scheduler = TickedScheduler(clock, 10ms)

        schedule_jobs(scheduler, observations, test_state)
        @show now(clock)
        while now(clock) < 50ms
            update!(scheduler)
        end

        @test test_state.timed_20ms_count[] == 2
        @test test_state.timed_30ms_count[] == 1
        @test test_state.asap_count[] == 4 # This is actually 4 because we never hit the 5 second mark
        @test test_state.channel_job_count[] == 2

        @test length(test_state.observations_received) == 2
        @test all(obs == 1 for obs in test_state.observations_received)
    end
end

@testitem "Integration test, Machine clock example" begin end
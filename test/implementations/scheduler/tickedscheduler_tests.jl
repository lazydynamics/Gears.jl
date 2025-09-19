@testitem "TickedScheduler" setup = [MockJobs, MockClocks] begin
    using Unitful
    import EnvironmentEngine: TickedScheduler, update!, set_time!, advance_time!, schedule!

    @testset "TickedScheduler creation and basic timekeeping" begin
        clock = MockClocks.MockClock()
        scheduler = TickedScheduler(clock, 1.0u"ms")
        @test scheduler.ticker.period == 1.0u"ms"
        @test scheduler.ticker.last_tick_time == 0.0u"ms"
        @test scheduler.ticker.accumulated_lag == 0.0u"s"

        set_time!(clock, 0.5u"ms")
        update!(scheduler)
        @test scheduler.ticker.last_tick_time == 0.0u"ms"
        @test scheduler.ticker.accumulated_lag == 0.5u"ms"

        set_time!(clock, 1.5u"ms")
        update!(scheduler)
        @test scheduler.ticker.last_tick_time == 1.0u"ms"
        @test scheduler.ticker.accumulated_lag == 0.5u"ms"

        advance_time!(clock, 1.0u"ms")
        update!(scheduler)
        @test scheduler.ticker.last_tick_time == 2.0u"ms"
        @test scheduler.ticker.accumulated_lag == 0.5u"ms"

        set_time!(clock, 10.0u"ms")
        update!(scheduler)
        @test scheduler.ticker.last_tick_time == 10.0u"ms"
        @test scheduler.ticker.accumulated_lag == 0.0u"ms"
    end

    @testset "TickedScheduler job scheduling" begin
        clock = MockClocks.MockClock()
        scheduler = TickedScheduler(clock, 1.0u"ms")

        order = []
        function f1()
            push!(order, 1)
        end

        function f2()
            push!(order, 2)
        end

        job1 = MockJobs.MockJob(f1)
        job2 = MockJobs.MockJob(f2)

        schedule!(scheduler, job1)
        schedule!(scheduler, job2)

        advance_time!(clock, 1.0u"ms")
        update!(scheduler)

        @test order == [1, 2]
    end
end

@testitem "TickedScheduler with threading enabled" setup = [MockJobs, MockClocks] begin
    import EnvironmentEngine: TickedScheduler, update!, set_time!, advance_time!, schedule!
    using Unitful
    using Base.Threads
    if Base.Threads.nthreads() > 1
        @testset "Threading preserves execution count" begin
            clock = MockClocks.MockClock()

            # Test both modes
            scheduler_seq = TickedScheduler(clock, 1.0ms; threading = false)
            scheduler_par = TickedScheduler(clock, 1.0ms; threading = true)

            # Create counting jobs
            jobs_seq = [MockJobs.CountingJob() for _ in 1:3]
            jobs_par = [MockJobs.CountingJob() for _ in 1:3]

            # Schedule jobs
            for job in jobs_seq
                schedule!(scheduler_seq, job)
            end
            for job in jobs_par
                schedule!(scheduler_par, job)
            end

            # Advance time and update
            advance_time!(clock, 10.0u"ms")
            update!(scheduler_seq)
            update!(scheduler_par)

            # Both should execute the same number of times
            seq_total = sum(job.counter[] for job in jobs_seq)
            par_total = sum(job.counter[] for job in jobs_par)
            @test seq_total == par_total
            @test seq_total > 0
        end

        @testset "All jobs execute per tick" begin
            clock = MockClocks.MockClock()
            scheduler = TickedScheduler(clock, 1.0u"ms"; threading = true)

            jobs = [MockJobs.CountingJob() for _ in 1:5]
            for job in jobs
                schedule!(scheduler, job)
            end

            advance_time!(clock, 1.0u"ms")
            update!(scheduler)

            # All jobs should have executed exactly once
            for job in jobs
                @test job.counter[] == 1
            end
        end

        @testset "Multiple ticks work correctly" begin
            clock = MockClocks.MockClock()
            scheduler = TickedScheduler(clock, 1.0u"ms"; threading = true)

            jobs = [MockJobs.CountingJob() for _ in 1:3]
            for job in jobs
                schedule!(scheduler, job)
            end

            # Advance time for 3 ticks
            advance_time!(clock, 3.0u"ms")
            update!(scheduler)

            # All jobs should have executed 3 times
            for job in jobs
                @test job.counter[] == 3
            end
        end
    else
        multiple_threads = false
        @test_broken multiple_threads
    end
end

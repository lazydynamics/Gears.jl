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
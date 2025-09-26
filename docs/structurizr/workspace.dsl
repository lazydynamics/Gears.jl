workspace "EnvironmentEngine" "Julia package for simulation scheduling" {
    model {
        developer = person "Simulation Developer" "Developers building agent-environment systems"
        
        envengine = softwareSystem "EnvironmentEngine" "Precise timing control and job scheduling" {
            api = container "Public API" "Julia Module" "every(), for_next(), update!() functions" {
                every_function = component "every()" "Julia Function" "Job creation function"
                for_next_function = component "for_next()" "Julia Function" "Time loop function"
                update_function = component "update!()" "Julia Function" "Scheduler update function"
            }
            
            scheduler = container "Scheduler System" "Julia Module" "TickedScheduler and job coordination" {
                ticked_scheduler = component "TickedScheduler" "Julia Type" "Main scheduler implementation"
                scheduler_interface = component "Scheduler Interface" "Abstract Type" "schedule!(), update!() contracts"
            }
            
            clock = container "Clock System" "Julia Module" "MachineClock, VirtualClock time abstraction" {
                machine_clock = component "MachineClock" "Julia Type" "System time clock"
                virtual_clock = component "VirtualClock" "Julia Type" "Controllable simulation clock"
                clock_interface = component "Clock Interface" "Abstract Type" "now() method contract"
            }
            
            jobs = container "Job System" "Julia Module" "TimedJob, AsapJob, EventJob implementations" {
                timed_job = component "TimedJob" "Julia Type" "Periodic execution jobs"
                event_job = component "EventJob" "Julia Type" "Event-driven jobs"
                asap_job = component "AsapJob" "Julia Type" "As-soon-as-possible jobs"
                job_interface = component "Job Interface" "Abstract Type" "progress!() method contract"
            }
            
            utils = container "Utilities" "Julia Module" "Ticker, singletons, error handling" {
                ticker = component "Ticker" "Julia Type" "Time accumulation and tick processing"
                singletons = component "Global Singletons" "Julia Module" "Global state management"
                errors = component "Error Handling" "Julia Module" "NotImplementedError and custom exceptions"
            }
        }
        
        agent = softwareSystem "Agent System (RxInfer)" "Intelligent agents that plan and act"
        environment = softwareSystem "Environment (User defined)" "Simulated world that agents interact with"
        
        developer -> envengine "Uses" "every(), for_next() API"
        envengine -> agent "Schedules" "Agent planning tasks"
        envengine -> environment "Schedules" "Environment updates"
        
        developer -> api "Calls" "Julia functions"
        api -> scheduler "Uses" "Schedules jobs"
        scheduler -> clock "Queries" "Current time"
        scheduler -> jobs "Executes" "Job progress"

        jobs -> agent "Calls" "Agent processes"
        jobs -> environment "Calls" "Agent processes" 

        # Component-level relationships
        every_function -> scheduler_interface "Creates jobs via" "schedule!()"
        update_function -> scheduler_interface "Calls" "update!()"
        
        ticked_scheduler -> clock_interface "Queries time" "now()"
        ticked_scheduler -> job_interface "Executes" "progress!()"
        ticked_scheduler -> ticker "Uses" "Scheduler timing"
        ticked_scheduler -> scheduler_interface "Implements"
        
        machine_clock -> clock_interface "Implements"
        virtual_clock -> clock_interface "Implements"
        
        timed_job -> job_interface "Implements"
        timed_job -> ticker "Uses" "Job timing"
        asap_job -> job_interface "Implements"
        event_job -> job_interface "Implements"

        for_next_function -> clock_interface "Takes as argument" "Which clock for timekeeping"
    }
    
    views {
        systemContext envengine {
            include *
            autoLayout
        }
        
        container envengine {
            include *
            autoLayout
        }
        
        component scheduler {
            include * 
            autoLayout
        }
        
        component clock {
            include *
            autoLayout
        }
        
        component jobs {
            include *
            autoLayout
        }
        
        component utils {
            include * 
            autoLayout
        }

        component api {
            include *
            autoLayout
        }
        
        theme default
    }
}
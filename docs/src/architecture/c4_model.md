# [C4 Model](@id architecture-c4-model)

This page contains the complete C4 model for EnvironmentEngine, showing the architecture at all levels from system context down to detailed components.

## Level 1: System Context

EnvironmentEngine sits at the heart of simulation systems, providing precise timing control for agent-environment interactions:

```mermaid
C4Context
    title System Context diagram for EnvironmentEngine

    Person(developer, "Simulation Developer", "Developers building agent-environment systems")

    System_Boundary(simulation, "Simulation Environment") {
        System(envengine, "EnvironmentEngine", "Precise timing control and job scheduling")
        System(agent, "Agent System (RxInfer)", "Intelligent agents that plan and act")
        System(environment, "Environment (User defined)", "Simulated world that agents interact with")
    }

    Rel(developer, envengine, "Uses", "every(), for_next() API")
    Rel(envengine, agent, "Schedules", "Agent planning tasks")
    Rel(envengine, environment, "Schedules", "Environment updates")
```

## Level 2: Container Architecture

EnvironmentEngine is organized into several key containers, each with specific responsibilities:

```mermaid
C4Container
    title Container diagram for EnvironmentEngine

    Person(developer, "Simulation Developer", "Developers using EnvironmentEngine")

    Container_Boundary(envengine, "EnvironmentEngine Package") {
        Container(api, "Public API", "Julia Module", "every(), for_next(), update!() functions")
        Container(scheduler, "Scheduler System", "Julia Module", "TickedScheduler and job coordination")
        Container(clock, "Clock System", "Julia Module", "MachineClock, VirtualClock time abstraction")
        Container(jobs, "Job System", "Julia Module", "TimedJob, AsapJob, EventJob implementations")
        Container(utils, "Utilities", "Julia Module", "Ticker, singletons, error handling")
    }

    Rel(developer, api, "Calls", "Julia functions")
    Rel(api, scheduler, "Uses", "Schedules jobs")
    Rel(scheduler, clock, "Queries", "Current time")
    Rel(scheduler, jobs, "Executes", "Job progress")
```

This level shows the main modules within EnvironmentEngine and how they interact. The Public API is the entry point, while the Scheduler coordinates between the Clock System and Job System.

## Level 3: Component Architecture

The detailed component view shows how the different parts of EnvironmentEngine interact:

```mermaid
C4Component
    title Component diagram for EnvironmentEngine

    Container_Boundary(envengine, "EnvironmentEngine Package") {
        Container_Boundary(api, "Public API") {
            Component(every_function, "every()", "Julia Function", "Job creation function")
            Component(for_next_function, "for_next()", "Julia Function", "Time loop function")
            Component(update_function, "update!()", "Julia Function", "Scheduler update function")
        }
        
        Container_Boundary(scheduler, "Scheduler System") {
            Component(ticked_scheduler, "TickedScheduler", "Julia Type", "Main scheduler implementation")
            Component(scheduler_interface, "Scheduler Interface", "Abstract Type", "schedule!(), update!() contracts")
        }
        
        Container_Boundary(clock, "Clock System") {
            Component(machine_clock, "MachineClock", "Julia Type", "System time clock")
            Component(virtual_clock, "VirtualClock", "Julia Type", "Controllable simulation clock")
            Component(clock_interface, "Clock Interface", "Abstract Type", "now() method contract")
        }
        
        Container_Boundary(jobs, "Job System") {
            Component(timed_job, "TimedJob", "Julia Type", "Periodic execution jobs")
            Component(event_job, "EventJob", "Julia Type", "Event-driven jobs")
            Component(asap_job, "AsapJob", "Julia Type", "As-soon-as-possible jobs")
            Component(job_interface, "Job Interface", "Abstract Type", "progress!() method contract")
        }
        
        Container_Boundary(utils, "Utilities") {
            Component(ticker, "Ticker", "Julia Type", "Time accumulation and tick processing")
            Component(singletons, "Global Singletons", "Julia Module", "Global state management")
            Component(errors, "Error Handling", "Julia Module", "NotImplementedError and custom exceptions")
        }
    }

    Rel(every_function, scheduler_interface, "Creates jobs via", "schedule!()")
    Rel(update_function, scheduler_interface, "Calls", "update!()")
    
    Rel(ticked_scheduler, clock_interface, "Queries time", "now()")
    Rel(ticked_scheduler, job_interface, "Executes", "progress!()")
    Rel(ticked_scheduler, ticker, "Uses", "Scheduler timing")
    Rel(ticked_scheduler, scheduler_interface, "Implements")
    
    Rel(machine_clock, clock_interface, "Implements")
    Rel(virtual_clock, clock_interface, "Implements")
    
    Rel(timed_job, job_interface, "Implements")
    Rel(timed_job, ticker, "Uses", "Job timing")
    Rel(asap_job, job_interface, "Implements")
    Rel(event_job, job_interface, "Implements")

    Rel(for_next_function, clock_interface, "Takes as argument", "Which clock for timekeeping")
```

This level shows the detailed components within each container. The TickedScheduler is the core component that coordinates between clocks and jobs, while the Ticker utility provides shared timing functionality.

## Key Relationships

### System Context Level
- **Simulation Developers** use EnvironmentEngine's simple API (`every()`, `for_next()`) to schedule tasks
- **EnvironmentEngine** coordinates timing between agent planning and environment updates, enabling complex simulation scenarios

### Container Level
- **Public API** provides the main interface for users
- **Scheduler System** manages job execution and timing coordination
- **Clock System** provides time abstraction with machine and virtual clocks
- **Job System** defines different types of executable tasks
- **Utilities** handle shared components like Ticker and global state management

### Component Level
- **TickedScheduler** coordinates between clocks and jobs, calling `progress!()` on jobs at appropriate times
- **Ticker** provides shared timing functionality used by both schedulers and timed jobs
- **Interface components** define contracts that concrete implementations must follow
- **Global singletons** provide default instances for simple use cases (though explicit instances are recommended)
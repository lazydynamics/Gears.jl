# Architecture Design

## System Overview

The EnvironmentEngine implements a mediator pattern architecture for time-based job scheduling. The system maintains a single source of truth for time through a centralized clock, with a scheduler distributing time deltas to individual jobs.

## Architectural Components

### Clock Interface
Abstract time provider that exposes a `now()` method. Implementations include:
- Real-time clock for production systems
- Virtual clock for simulation and testing

### Job Interface
Executable units implementing an `execute` method. Jobs can access states of objects they describe.

### Scheduler
Central mediator that:
- Maintains scheduled job registry
- Polls clock for elapsed time
- Distributes time deltas to registered jobs
- Manages job lifecycle (enable/disable/unschedule)

### TimedJob
Internal data structure containing:
- Job reference
- Execution period
- Time accumulator
- Enabled state

## Execution Model

1. **Initialization**: Clock and scheduler instantiated, jobs registered with execution periods
2. **Runtime**: Scheduler polls clock, calculates time delta, forwards delta to all registered jobs
3. **Job Execution**: Jobs receive time delta from scheduler, update internal accumulators, execute when thresholds met

## Design Patterns

- **Mediator**: Scheduler coordinates between Clock and Jobs
- **Strategy**: Multiple Clock implementations provide different time sources
- **Template Method**: Job interface defines execution contract

## Dependencies

- Clock implementations depend on Clock interface
- Job implementations depend on Job interface  
- Scheduler depends on Clock interface and Job interface
- No circular dependencies between components


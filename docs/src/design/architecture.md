# Architecture Overview

## System Design

The EnvironmentEngine implements a mediator pattern architecture for time-based job scheduling. The system maintains a single source of truth for time through a centralized clock, with a scheduler distributing time deltas to individual jobs.

## Core Principles

- **Single time source**: Centralized clock provides authoritative time progression
- **Mediator pattern**: Scheduler coordinates between clock and jobs
- **Unified execution model**: All jobs implement the same interface regardless of trigger type
- **Separation of concerns**: Timekeeping, job execution, and coordination are cleanly separated

## High-Level Components

### Clock Interface
Abstract time provider that exposes a `now()` method. Multiple implementations allow for different time sources:
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

## Design Patterns

- **Mediator**: Scheduler coordinates between Clock and Jobs
- **Strategy**: Multiple Clock implementations provide different time sources
- **Template Method**: Job interface defines execution contract

## Dependencies

- Clock implementations depend on Clock interface
- Job implementations depend on Job interface  
- Scheduler depends on Clock interface and Job interface
- No circular dependencies between components


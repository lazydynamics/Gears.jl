# Architecture Overview

## System Design

The EnvironmentEngine implements a mediator pattern architecture for time-based task scheduling. The system maintains a single source of truth for time through a centralized clock, with a scheduler distributing time deltas to individual tasks.

## Core Principles

- **Single time source**: Centralized clock provides authoritative time progression
- **Mediator pattern**: TaskScheduler coordinates between clock and tasks
- **Unified execution model**: All tasks implement the same interface regardless of trigger type
- **Separation of concerns**: Timekeeping, task execution, and coordination are cleanly separated

## High-Level Components

### Clock Interface
Abstract time provider that exposes a `now()` method. Multiple implementations allow for different time sources:
- Real-time clock for production systems
- Virtual clock for simulation and testing

### Task Interface
Executable units implementing an `execute` method. Tasks can access states of objects they describe.

### TaskScheduler
Central mediator that:
- Maintains scheduled task registry
- Polls clock for elapsed time
- Distributes time deltas to registered tasks
- Manages task lifecycle (enable/disable/unschedule)

## Design Patterns

- **Mediator**: TaskScheduler coordinates between Clock and Tasks
- **Strategy**: Multiple Clock implementations provide different time sources
- **Template Method**: Task interface defines execution contract

## Dependencies

- Clock implementations depend on Clock interface
- Task implementations depend on Task interface  
- TaskScheduler depends on Clock interface and Task interface
- No circular dependencies between components

## Performance Characteristics

- O(n) execution complexity where n is number of scheduled tasks
- Constant memory overhead per scheduled task
- No dynamic allocation during execution loop

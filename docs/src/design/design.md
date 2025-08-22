# Architecture Design

## System Overview

The EnvironmentEngine implements a mediator pattern architecture for time-based task scheduling. The system maintains a single source of truth for time through a centralized clock, with a scheduler distributing time deltas to individual tasks.

## Architectural Components

### Clock Interface
Abstract time provider that exposes a `now()` method. Implementations include:
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

### ScheduledTask
Internal data structure containing:
- Task reference
- Execution period
- Time accumulator
- Enabled state

## Execution Model

1. **Initialization**: Clock and scheduler instantiated, tasks registered with execution periods
2. **Runtime**: Scheduler polls clock, calculates time delta, forwards delta to all registered tasks
3. **Task Execution**: Tasks receive time delta from scheduler, update internal accumulators, execute when thresholds met

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

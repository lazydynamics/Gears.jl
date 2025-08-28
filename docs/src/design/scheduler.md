# Scheduler Design

## Overview

The Scheduler implements the mediator pattern, serving as the central coordinator between the clock system and individual jobs. It maintains a single source of truth for time distribution while keeping jobs decoupled from each other and from timekeeping logic.

## Core Responsibilities

### Time Management
- Polls the clock for elapsed time
- Calculates time deltas between execution cycles
- Distributes time deltas to all registered jobs

### Job Registry
- Maintains collection of scheduled jobs
- Handles job registration and deregistration

### Execution Coordination
- Calls `execute(dt)` on all registered jobs
- Provides consistent time progression to all jobs
- Maintains execution order and consistency

## Execution Model

### Main Execution Loop
The scheduler polls the clock, calculates time deltas, and distributes them to all registered jobs.

### Time Distribution
- Scheduler receives time delta from clock
- All jobs receive the same time delta on each cycle
- Jobs internally decide whether to execute based on their trigger logic
- No job execution affects timing of other jobs

## Job Management

### Registration
Jobs are registered with the scheduler and stored in an internal collection.

### Lifecycle Operations
- **Enable/Disable**: Jobs can be temporarily disabled without removal
- **Unschedule**: Complete removal of jobs from the system
- **Reset**: Clear all job state and timing accumulators

## Internal Data Structures

The scheduler maintains internal structures to track registered jobs and their state.

## Global Scheduler Instance

The system provides a global scheduler instance for convenience:
- Automatically created when package loads
- Uses default clock implementation
- Can be configured or replaced at runtime
- Provides the `every()` function interface

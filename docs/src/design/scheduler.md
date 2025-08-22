# Scheduler Design

## Overview

The Scheduler implements the mediator pattern, serving as the central coordinator between the clock system and individual tasks. It maintains a single source of truth for time distribution while keeping tasks decoupled from each other and from timekeeping logic.

## Core Responsibilities

### Time Management
- Polls the clock for elapsed time
- Calculates time deltas between execution cycles
- Distributes time deltas to all registered tasks

### Task Registry
- Maintains collection of scheduled tasks
- Handles task registration and deregistration
- Manages task lifecycle (enable/disable)

### Execution Coordination
- Calls `execute(dt)` on all registered tasks
- Provides consistent time progression to all tasks
- Maintains execution order and consistency

## Execution Model

### Main Execution Loop
The scheduler polls the clock, calculates time deltas, and distributes them to all registered tasks.

### Time Distribution
- Scheduler receives time delta from clock
- All tasks receive the same time delta on each cycle
- Tasks internally decide whether to execute based on their trigger logic
- No task execution affects timing of other tasks

## Task Management

### Registration
Tasks are registered with the scheduler and stored in an internal collection.

### Lifecycle Operations
- **Enable/Disable**: Tasks can be temporarily disabled without removal
- **Unschedule**: Complete removal of tasks from the system
- **Reset**: Clear all task state and timing accumulators

## Internal Data Structures

The scheduler maintains internal structures to track registered tasks and their state.

## Global Scheduler Instance

The system provides a global scheduler instance for convenience:
- Automatically created when package loads
- Uses default clock implementation
- Can be configured or replaced at runtime
- Provides the `every()` function interface

# Drone example

The simplest example that uses the environment engine is a single agent that interacts with an environment with an associated clock.

```julia
using EnvironmentEngine

initialize_clock!(real_time_factor=1.0)

env = Environment()
agent = Agent()

obs_cache = CircularBuffer{ConcreteObservationType}(10)

# Sensor frequency
every(1ms) do dt
    push!(obs_cache, generate_observation(env, agent))
end

# State update as soon as observation is available
every(obs_cache) do obs
    state_update!(agent, obs)
end

# Planning as soon as state is possible
every(asap) do 
    plan!(agent)
end

# Action execution on hardware limitation frequency
every(2ms) do dt
    act!(agent, env)
end

# Environment update on seperate frequency (e.g. physics engine)
every(1ms) do dt
    update!(env, dt)
end

```
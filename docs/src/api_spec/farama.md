# Farama (standard RL environment) 

For farama environments, we do not need a clock.

```julia
using EnvironmentEngine

env = Environment()
agent = Agent()

obs_cache = CircularBuffer{ConcreteObservationType}(1)
action_cache = CircularBuffer{ConcreteActionType}(1)

every(obs_cache) do obs
    push!(action_cache, action_inference(agent, obs))
end

every(action_cache) do action
    obs = step!(env, action)
    push!(obs_cache, obs)
end




```
data:extend({
  {
    type = "space-connection",
    name = "nauvis-lumos",
    subgroup = "space-connection",
    from = "nauvis",
    to = "lumos",
    order = "b-a",  -- after nauvis-vulcanus (a-*)
    length = 10000,
    asteroid_spawn_definitions = {
      {type = "entity", asteroid = "metallic-asteroid-small", probability = 0.08, speed = 0.2},
      {type = "entity", asteroid = "rocky-asteroid-small",    probability = 0.08, speed = 0.2},
      {type = "entity", asteroid = "metallic-asteroid-medium",probability = 0.02, speed = 0.15},
    },
  },
})

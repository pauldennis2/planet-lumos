local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

data:extend({
  {
    type = "space-connection",
    name = "nauvis-lumos",
    subgroup = "planet-connections",
    from = "nauvis",
    to = "lumos",
    order = "b-a",
    length = 10000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_lumos),
  },
})

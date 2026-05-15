local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

-- Custom surface property used to gate Lumos-only entity placement.
data:extend({{
  type = "surface-property",
  name = "lumos-surface",
  default_value = 0,
}})

data:extend({
  {
    type = "planet",
    name = "lumos",
    subgroup = "planets",
    label_color = {r = 0.75, g = 0.85, b = 1.0},
    icon = "__base__/graphics/icons/nauvis.png",
    icon_size = 64,
    starmap_icon = "__base__/graphics/icons/nauvis.png",
    starmap_icon_size = 64,
    distance = 20,
    orientation = 0.25,
    magnitude = 0.9,
    draw_orbit = true,

    -- Nauvis tile generation. Only lumite is allowed to entity-autoplace.
    map_gen_settings = {
      autoplace_controls = {
        lumite = {frequency = 1, size = 1, richness = 1},
      },
      autoplace_settings = {
        tile      = {treat_missing_as_default = true},
        entity    = {treat_missing_as_default = false},
        decorative= {treat_missing_as_default = false},
      },
      cliff_settings = {cliff_elevation_interval = 0},
      peaceful_mode = true,
    },

    surface_properties = {
      ["day-night-cycle"] = 25000,
      ["magnetic-field"]  = 99,
      ["solar-power"]     = 100,
      pressure            = 1000,
      gravity             = 10,
      ["lumos-surface"]   = 1,
    },

    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_lumos, 0.9),
  },
})

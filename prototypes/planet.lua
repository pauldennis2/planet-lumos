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

    map_gen_settings = {
      property_expression_names = {
        ["entity:lumite:probability"]     = "lumos_lumite_probability",
        ["entity:lumite:richness"]        = "lumos_lumite_richness",
        ["entity:light-vent:probability"] = "lumos_light_vent_probability",
        ["entity:light-vent:richness"]    = "lumos_light_vent_richness",
      },
      autoplace_settings = {
        tile = {
          treat_missing_as_default = false,
          settings = {
            ["lumos-ground"] = {},
            ["lumos-lava"]   = {},
          },
        },
        entity = {
          treat_missing_as_default = false,
          settings = {
            ["lumite"]      = {},
            ["light-vent"]  = {},
          },
        },
        decorative = {treat_missing_as_default = false},
      },
      cliff_settings = {cliff_elevation_interval = 0},
      peaceful_mode = true,
    },

    surface_properties = {
      ["day-night-cycle"] = 720000000,  -- effectively permanent night (~138 real days per cycle)
      ["magnetic-field"]  = 99,
      ["solar-power"]     = 0,
      pressure            = 1000,
      gravity             = 10,
      ["lumos-surface"]   = 1,
    },

    surface_render_parameters = {
      -- Use the full Fulgora LUT range. Frozen at daytime=0.5, Factorio interpolates
      -- 50/50 between fulgora-3-after-sunset and fulgora-4-before-dawn — the same
      -- blend Fulgora uses at its darkest night, where lamps are confirmed to work.
      -- Using pure fulgora-4 at all times black-crushes lamp light circles.
      day_night_cycle_color_lookup = {
        {0.00, "__space-age__/graphics/lut/fulgora-1-noon.png"},
        {0.20, "__space-age__/graphics/lut/fulgora-1-noon.png"},
        {0.30, "__space-age__/graphics/lut/fulgora-2-afternoon.png"},
        {0.40, "__space-age__/graphics/lut/fulgora-3-after-sunset.png"},
        {0.60, "__space-age__/graphics/lut/fulgora-4-before-dawn.png"},
        {0.70, "__space-age__/graphics/lut/fulgora-5-morning.png"},
        {1.00, "__space-age__/graphics/lut/fulgora-1-noon.png"},
      },
    },

    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_lumos, 0.9),
  },
})

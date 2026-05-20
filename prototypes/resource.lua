local resource_autoplace = require("resource-autoplace")

resource_autoplace.initialize_patch_set("light-vent", false)

data:extend({
  {
    type = "autoplace-control",
    name = "light-vent",
    richness = true,
    category = "resource",
    order = "b-b",
  },
  {
    type = "autoplace-control",
    name = "lumite",
    richness = true,
    category = "resource",
    order = "b-a",
  },
})

-- Inherit iron-ore's sprite sheets so we have valid graphics without custom art.
local lumite = table.deepcopy(data.raw["resource"]["iron-ore"])
lumite.name               = "lumite"
lumite.localised_name     = nil
lumite.localised_description = nil
lumite.map_color          = {r = 0.45, g = 0.55, b = 0.9}
lumite.minable            = {mining_time = 1, result = "lumite", required_fluid = "liquid-light", fluid_amount = 10}
lumite.autoplace          = resource_autoplace.resource_autoplace_settings({
  name                          = "lumite",
  order                         = "b-a",
  autoplace_control_name        = "lumite",
  base_density                  = 10,
  base_spots_per_km2            = 2,
  has_starting_area_placement   = true,
  regular_rq_factor_multiplier  = 1.0,
  starting_rq_factor_multiplier = 1.4,
})
data:extend({lumite})

data:extend({
  {
    type = "resource",
    name = "light-vent",
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    flags = {"placeable-neutral"},
    category = "basic-fluid",
    subgroup = "mineable-fluids",
    order = "b",
    infinite = true,
    highlight = true,
    minimum = 60000,
    normal = 300000,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 12,
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 32 * 32,
    minable = {
      mining_time = 1,
      results = {
        {
          type = "fluid",
          name = "liquid-light",
          amount_min = 10,
          amount_max = 10,
          probability = 1,
        }
      }
    },
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings {
      name = "light-vent",
      order = "b",
      base_density = 8,
      base_spots_per_km2 = 3,
      random_probability = 1/32,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1,
      has_starting_area_placement = true,
      starting_rq_factor_multiplier = 1.5,
    },
    stage_counts = {0},
    stages = {
      sheet = util.sprite_load("__planet-lumos__/graphics/entity/light-vent",
      {
        priority = "extra-high",
        variation_count = 1,
        frame_count = 4,
        animation_speed = 0.5,
      })
    },
    map_color = {r = 1.0, g = 0.9, b = 0.3},
  },
})

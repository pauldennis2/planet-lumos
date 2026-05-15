local resource_autoplace = require("resource-autoplace")

data:extend({
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
lumite.minable            = {mining_time = 1, result = "lumite"}
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

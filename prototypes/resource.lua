-- Noise layer drives the random placement pattern for lumite patches.
data:extend({{type = "noise-layer", name = "lumite"}})

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
lumite.map_color          = {r = 0.45, g = 0.55, b = 0.9}  -- blue-ish tint on minimap
lumite.minable            = {mining_time = 1, result = "lumite"}
lumite.autoplace          = {
  control = "lumite",
  order   = "b-a",
  peaks   = {
    {noise_layer = "lumite", noise_octaves_difference = -2, noise_persistence = 0.9},
  },
  sharpness                        = 0.3,
  richness_base                    = 500,
  richness_multiplier              = 2000,
  richness_multiplier_distance_bonus = 8,
  starting_area_amount             = 2000,
  starting_area_size               = 3,
}
data:extend({lumite})

local avg_w  = settings.startup["lumos-average-width"].value
local snek_n = settings.startup["lumos-snek-number"].value

-- How far the snake centerline drifts from the x-axis (tiles).
-- At snek=1: gentle drift. At snek=10: wild amplitude.
local amplitude   = avg_w * snek_n * 0.5

-- How quickly the path turns. snek^0.8 keeps low values gentle, high values tight.
local path_freq   = (snek_n ^ 0.8) / 2000

-- Half-width base and variation. Floor of 2.5 → minimum 5-tile width.
local half_w_base = avg_w / 2
local half_w_var  = half_w_base * 0.3

-- Width modulation frequency: slower than the path so width feels independent.
local width_freq  = 0.003

-- Spawn bulge: widens the snake around x=0,y=0 so the landing area feels like
-- the inside of a stomach. Linear falloff from bulge_r tiles out.
local bulge_r        = 150
local bulge_extra_hw = avg_w * 1.5          -- extra half-width right at spawn
local bulge_scale    = bulge_extra_hw / bulge_r

-- Snake mask: positive = inside the snake, negative = outside.
-- center_y  : multioctave noise sampled along x only (y=0) → the wandering centerline
-- half_width: slowly varying half-width, floored at 2.5 tiles (5 tile minimum width),
--             plus a spawn bulge that fades to zero at bulge_r tiles from origin.
data:extend({
  {
    type = "noise-expression",
    name = "lumos_snake_mask",
    expression = string.format(
      "max(2.5, %f + basis_noise{x=x, y=0, seed0=map_seed, seed1=4421, input_scale=%f, output_scale=%f}" ..
      " + max(0, %f - sqrt(x*x+y*y)) * %f)" ..
      " - abs(y - multioctave_noise{x=x, y=0, seed0=map_seed, seed1=7294, octaves=3, persistence=0.6, input_scale=%f, output_scale=%f})",
      half_w_base,
      width_freq, half_w_var,
      bulge_r, bulge_scale,
      path_freq, amplitude
    ),
  },
})

-- Lumite ore: 2-tile strip along both edges of the snake.
-- lumos_snake_mask is 0 at the edge, positive inside, negative outside.
-- if(mask > 0, 2 - mask, -1) is positive only when 0 < mask < 2.
data:extend({
  {
    type = "noise-expression",
    name = "lumos_lumite_probability",
    expression = "if(lumos_snake_mask, 2 - lumos_snake_mask, -1)",
  },
  {
    type = "noise-expression",
    name = "lumos_lumite_richness",
    expression = "max(150, 150 + distance / 4)",
  },
})

-- Land tile: volcanic-soil-dark graphics, Lumos autoplace.
local ground = table.deepcopy(data.raw["tile"]["volcanic-soil-dark"])
ground.name                = "lumos-ground"
ground.sprite_usage_surface = nil  -- allow rendering on Lumos, not just Vulcanus
ground.autoplace           = { probability_expression = "lumos_snake_mask" }

-- Lava tile: standard lava graphics/hazard, fills everywhere ground doesn't win.
local lava_out = table.deepcopy(data.raw["tile"]["lava"])
lava_out.name                = "lumos-lava"
lava_out.sprite_usage_surface = nil
lava_out.autoplace           = { probability_expression = "1" }

data:extend({ ground, lava_out })

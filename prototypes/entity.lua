local foundry = data.raw["assembling-machine"]["foundry"]

local new_w = 4
local new_h = 4
local old_w = foundry.tile_width    -- 5
local old_h = foundry.tile_height   -- 5
local sx         = new_w / old_w    -- 0.8
local sy         = new_h / old_h    -- 0.8
local area_scale = (new_w * new_h) / (old_w * old_h)  -- 16/25

-- Scale pipe-connection positions so fluids still reach the entity boundary.
local function scale_fluid_boxes(fluid_boxes)
  if not fluid_boxes then return end
  for _, fb in pairs(fluid_boxes) do
    if fb.pipe_connections then
      for _, pc in pairs(fb.pipe_connections) do
        if pc.position then
          pc.position = {pc.position[1] * sx, pc.position[2] * sy}
        end
        if pc.positions then
          for i, pos in ipairs(pc.positions) do
            pc.positions[i] = {pos[1] * sx, pos[2] * sy}
          end
        end
      end
    end
  end
end

local mini = table.deepcopy(foundry)

mini.name               = "foundry-mini1"
mini.localised_name     = nil
mini.localised_description = nil

-- Footprint: 4×4
mini.tile_width   = new_w
mini.tile_height  = new_h
mini.collision_box = {{-(new_w / 2 - 0.3), -(new_h / 2 - 0.3)},
                      { (new_w / 2 - 0.3),  (new_h / 2 - 0.3)}}
mini.selection_box = {{-new_w / 2, -new_h / 2},
                      { new_w / 2,  new_h / 2}}

-- Crafting speed proportional to tile area; power + module slots inherited unchanged.
mini.crafting_speed = foundry.crafting_speed * area_scale

-- Picking up the entity returns the mini item, not the full foundry.
mini.minable = {mining_time = 0.5, result = "foundry-mini1"}

-- Can only be placed on Lumos (surface-property defined in planet.lua).
mini.surface_conditions = {{property = "lumos-surface", min = 1}}

scale_fluid_boxes(mini.fluid_boxes)

data:extend({mini})

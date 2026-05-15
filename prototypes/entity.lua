local foundry = data.raw["assembling-machine"]["foundry"]

local new_w = 4
local new_h = 4
-- tile_width/tile_height are not stored on the prototype; the foundry is known to be 5×5.
local old_w = 5
local old_h = 5
local sx         = new_w / old_w    -- 0.8
local sy         = new_h / old_h    -- 0.8
local area_scale = (new_w * new_h) / (old_w * old_h)  -- 16/25

-- Recursively scale all sprite/animation visuals.
-- Tables with a filename/filenames/layers key are sprites: scale their `scale` field
-- (defaulting the implicit 1.0 when unset). Also scale shift vectors so overlays
-- stay correctly positioned relative to the smaller footprint.
local function scale_sprites(t, factor)
  if type(t) ~= "table" then return end
  if t.filename ~= nil or t.filenames ~= nil or t.layers ~= nil then
    t.scale = (t.scale or 1.0) * factor
  end
  if t.shift ~= nil and type(t.shift) == "table" and #t.shift == 2
     and type(t.shift[1]) == "number" then
    t.shift = {t.shift[1] * factor, t.shift[2] * factor}
  end
  for _, v in pairs(t) do
    if type(v) == "table" then
      scale_sprites(v, factor)
    end
  end
end

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

-- Shrink the rendering bounding box to match (controls sprite culling).
if mini.drawing_box then
  mini.drawing_box = {
    {mini.drawing_box[1][1] * sx, mini.drawing_box[1][2] * sy},
    {mini.drawing_box[2][1] * sx, mini.drawing_box[2][2] * sy},
  }
end

-- Crafting speed proportional to tile area; power + module slots inherited unchanged.
mini.crafting_speed = foundry.crafting_speed * area_scale

-- Picking up the entity returns the mini item, not the full foundry.
mini.minable = {mining_time = 0.5, result = "foundry-mini1"}

-- No placement restriction; placeable anywhere a regular foundry can go.
mini.surface_conditions = nil

-- Apply visual scaling before fluid box position scaling.
scale_sprites(mini, sx)
scale_fluid_boxes(mini.fluid_boxes)

data:extend({mini})

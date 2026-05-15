-- Shallow-copy fluid_boxes, deep-copying only pipe_connections (tiny position data).
-- pipe_picture and other sprite fields are preserved as shared references.
local function scale_fluid_boxes(fluid_boxes, sx, sy)
  if not fluid_boxes then return nil end
  local result = {}
  for i, fb in ipairs(fluid_boxes) do
    local new_fb = {}
    for k, v in pairs(fb) do
      new_fb[k] = v  -- shallow: preserves pipe_picture/pipe_picture_frozen refs
    end
    if fb.pipe_connections then
      new_fb.pipe_connections = table.deepcopy(fb.pipe_connections)
      for _, pc in pairs(new_fb.pipe_connections) do
        if pc.position then
          pc.position = {pc.position[1] * sx, pc.position[2] * sy}
        end
        if pc.positions then
          for j, pos in ipairs(pc.positions) do
            pc.positions[j] = {pos[1] * sx, pos[2] * sy}
          end
        end
      end
    end
    result[i] = new_fb
  end
  return result
end

-- Shallow-copies the base entity so large graphics_set and pipe_picture tables
-- (loaded from Space Age picture modules) are referenced, not duplicated.
-- Only the fields we actually change are replaced or freshly constructed.
local function make_mini(base_name, mini_name, new_w, new_h, old_w, old_h)
  local base = data.raw["assembling-machine"][base_name]
  local sx = new_w / old_w
  local sy = new_h / old_h
  local area_scale = (new_w * new_h) / (old_w * old_h)

  local mini = {}
  for k, v in pairs(base) do
    mini[k] = v
  end

  mini.name               = mini_name
  mini.localised_name     = nil
  mini.localised_description = nil

  mini.tile_width  = new_w
  mini.tile_height = new_h
  mini.collision_box = {{-(new_w / 2 - 0.3), -(new_h / 2 - 0.3)},
                        { (new_w / 2 - 0.3),  (new_h / 2 - 0.3)}}
  mini.selection_box = {{-new_w / 2, -new_h / 2},
                        { new_w / 2,  new_h / 2}}

  if base.drawing_box then
    mini.drawing_box = {
      {base.drawing_box[1][1] * sx, base.drawing_box[1][2] * sy},
      {base.drawing_box[2][1] * sx, base.drawing_box[2][2] * sy},
    }
  end
  if base.drawing_box_vertical_extension then
    mini.drawing_box_vertical_extension = base.drawing_box_vertical_extension * sy
  end

  mini.crafting_speed     = base.crafting_speed * area_scale
  mini.minable            = {mining_time = 0.5, result = mini_name}
  mini.surface_conditions = nil

  mini.fluid_boxes = scale_fluid_boxes(base.fluid_boxes, sx, sy)

  return mini
end

data:extend({
  -- 5×5 → 4×4,  area_scale = 16/25
  make_mini("foundry",               "foundry-mini1",    4, 4, 5, 5),
  -- 5×5 → 3×3,  area_scale = 9/25
  make_mini("foundry",               "foundry-mini2",    3, 3, 5, 5),
  -- 3×3 → 2×2,  area_scale = 4/9
  make_mini("assembling-machine-3",  "assembler-mini1",  2, 2, 3, 3),
  -- 4×4 → 3×3,  area_scale = 9/16
  make_mini("electromagnetic-plant", "em-plant-mini1",   3, 3, 4, 4),
  -- 5×5 → 4×4,  area_scale = 16/25
  make_mini("cryogenic-plant",       "cryo-plant-mini1", 4, 4, 5, 5),
})

-- Bob's Assembling Machine 6: 3×3 → 2×2, area_scale = 4/9
if mods["bobassembly"] and data.raw["assembling-machine"]["bob-assembling-machine-6"] then
  data:extend({make_mini("bob-assembling-machine-6", "bob-am6-mini1", 2, 2, 3, 3)})
end

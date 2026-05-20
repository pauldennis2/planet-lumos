local function scale_fluid_boxes(fluid_boxes, sx, sy, new_w, new_h)
  if not fluid_boxes then return nil end
  local max_x = new_w / 2 - 0.5
  local max_y = new_h / 2 - 0.5
  local function snap(v, max)
    if math.abs(v) > max / 2 then return v > 0 and max or -max end
    local s = math.max(-max, math.min(max, math.floor(v + 0.5)))
    -- Even-tile entities (half-integer max) have no centre tile; x=0 lands on a
    -- tile boundary. Nudge to the nearest positive tile centre (matches Bob's pattern).
    if s == 0 and math.floor(max) ~= max then return 0.5 end
    return s
  end
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
          pc.position = {snap(pc.position[1] * sx, max_x),
                         snap(pc.position[2] * sy, max_y)}
        end
        if pc.positions then
          for j, pos in ipairs(pc.positions) do
            pc.positions[j] = {snap(pos[1] * sx, max_x),
                               snap(pos[2] * sy, max_y)}
          end
        end
      end
    end
    result[i] = new_fb
  end
  return result
end

-- Copies only the spine of a sprite/animation table tree that leads to scale or
-- shift fields, returning shared references for subtrees that have neither.
-- This avoids duplicating heavy frame/stripe data while still rescaling visuals.
local function rescale_gs(t, factor)
  local copy = {}
  local changed = false
  for k, v in pairs(t) do
    if k == "scale" and type(v) == "number" then
      copy[k] = v * factor
      changed = true
    elseif k == "shift" and type(v) == "table" then
      copy[k] = {v[1] * factor, v[2] * factor}
      changed = true
    elseif type(v) == "table" then
      local new_v = rescale_gs(v, factor)
      copy[k] = new_v
      if new_v ~= v then changed = true end
    else
      copy[k] = v
    end
  end
  return changed and copy or t
end

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

  mini.crafting_speed     = math.floor(base.crafting_speed * area_scale * 10) / 10
  mini.minable            = {mining_time = 0.5, result = mini_name}
  mini.surface_conditions = nil

  mini.fluid_boxes = scale_fluid_boxes(base.fluid_boxes, sx, sy, new_w, new_h)

  if mini.fluid_boxes then
    for _, fb in ipairs(mini.fluid_boxes) do
      if fb.pipe_picture then
        fb.pipe_picture = rescale_gs(fb.pipe_picture, sx)
      end
    end
  end

  if base.graphics_set then
    mini.graphics_set = rescale_gs(base.graphics_set, sx)
  end
  if base.pipe_picture_frozen then
    mini.pipe_picture_frozen = rescale_gs(base.pipe_picture_frozen, sx)
  end

  return mini
end

data:extend({
  -- 5×5 → 4×4,  area_scale = 16/25
  make_mini("foundry",               "foundry-mini1",    4, 4, 5, 5),
  -- 5×5 → 3×3,  area_scale = 9/25
  make_mini("foundry",               "foundry-mini2",    3, 3, 5, 5),
  -- 4×4 → 3×3,  area_scale = 9/16
  make_mini("electromagnetic-plant", "em-plant-mini1",   3, 3, 4, 4),
  -- 3×3 → 2×2,  area_scale = 4/9
  make_mini("chemical-plant",        "chem-plant-mini1", 2, 2, 3, 3),
})

if not mods["bobassembly"] then
  -- 3×3 → 2×2,  area_scale = 4/9
  data:extend({make_mini("assembling-machine-3", "assembler-mini1", 2, 2, 3, 3)})
end

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-assembling-machine-6"] then
  data:extend({make_mini("bob-assembling-machine-6", "bob-am6-mini1", 2, 2, 3, 3)})
end

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-chemical-plant-4"] then
  data:extend({make_mini("bob-chemical-plant-4", "bob-chem4-mini1", 2, 2, 3, 3)})
end

do
  local base = data.raw["assembling-machine"]["assembling-machine-3"]
  local mtf = {}
  for k, v in pairs(base) do mtf[k] = v end
  mtf.name                               = "miniaturization-testing-facility"
  mtf.localised_name                     = nil
  mtf.localised_description              = nil
  mtf.tile_width                         = 12
  mtf.tile_height                        = 12
  mtf.collision_box                      = {{-5.7, -5.7}, {5.7, 5.7}}
  mtf.selection_box                      = {{-6, -6}, {6, 6}}
  mtf.drawing_box                        = nil
  mtf.drawing_box_vertical_extension     = nil
  mtf.module_slots                       = 4
  mtf.allowed_effects                    = {"consumption", "speed", "productivity", "pollution", "quality"}
  mtf.crafting_speed                     = 20
  mtf.crafting_categories               = {"miniaturization"}
  mtf.minable                            = {mining_time = 1.0, result = "miniaturization-testing-facility"}
  mtf.energy_usage                       = "500kW"
  mtf.fluid_boxes                        = nil
  mtf.fluid_boxes_off_when_no_fluid_recipe = nil
  mtf.surface_conditions                 = nil
  mtf.next_upgrade                       = nil
  mtf.fast_replaceable_group             = nil
  if base.graphics_set then
    mtf.graphics_set = rescale_gs(base.graphics_set, 4)
  end
  data:extend({mtf})
end

do
  local base = data.raw["lab"]["lab"]
  local mrf = {}
  for k, v in pairs(base) do mrf[k] = v end
  mrf.name                   = "miniaturization-research-facility"
  mrf.localised_name         = nil
  mrf.localised_description  = nil
  mrf.minable                = {mining_time = 0.5, result = "miniaturization-research-facility"}
  local mrf_inputs = {"foundry-miniaturization-data", "em-plant-miniaturization-data"}
  if not mods["bobassembly"] then
    table.insert(mrf_inputs, "assembler-miniaturization-data")
  end
  mrf.inputs = mrf_inputs
  mrf.fast_replaceable_group = nil
  mrf.surface_conditions     = nil
  mrf.next_upgrade           = nil
  data:extend({mrf})
end

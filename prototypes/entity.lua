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

do
  local base = data.raw["lamp"]["small-lamp"]
  local scale = 5  -- big lamp is 5× the small lamp in each dimension

  local big = {}
  for k, v in pairs(base) do big[k] = v end

  big.name                = "big-lamp"
  big.localised_name      = nil
  big.localised_description = nil
  big.icon                = "__base__/graphics/icons/small-lamp.png"
  big.icon_size           = 64
  big.tile_width          = 5
  big.tile_height         = 5
  big.collision_box       = {{-1.9, -1.9}, {1.9, 1.9}}
  big.selection_box       = {{-2.5, -2.5}, {2.5, 2.5}}
  big.max_health          = 500
  big.fast_replaceable_group = nil
  big.minable             = {mining_time = 0.5, result = "big-lamp"}
  big.energy_usage_per_tick = "25kW"  -- 5× small lamp

  -- size = 60 gives roughly 15-tile effective radius (small lamp: size=40, ~10-tile effective).
  -- NOTE: quality scaling of light.size is not supported by the lamp prototype natively;
  -- a control.lua on_entity_settings_pasted handler would be needed to implement it.
  big.light               = {intensity = 0.9, size = 60, color = {1, 1, 0.75}}
  big.light_when_colored  = {intensity = 0,   size = 15, color = {1, 1, 0.75}}
  big.glow_size           = 15

  -- Scale sprites 5× by multiplying scale and shift values.
  big.picture_off = {
    layers = {
      {
        filename = "__base__/graphics/entity/small-lamp/lamp.png",
        priority = "high",
        width    = 83,
        height   = 70,
        shift    = util.by_pixel(0.25 * scale, 3 * scale),
        scale    = 0.5 * scale,
      },
      {
        filename        = "__base__/graphics/entity/small-lamp/lamp-shadow.png",
        priority        = "high",
        width           = 76,
        height          = 47,
        shift           = util.by_pixel(4 * scale, 4.75 * scale),
        draw_as_shadow  = true,
        scale           = 0.5 * scale,
      },
    },
  }
  big.picture_on = {
    filename = "__base__/graphics/entity/small-lamp/lamp-light.png",
    priority = "high",
    width    = 90,
    height   = 78,
    shift    = util.by_pixel(0, -7 * scale),
    scale    = 0.5 * scale,
  }

  -- Drop circuit connector — position offsets are hardcoded for 1×1 and would misplace on 5×5.
  big.circuit_connector       = nil
  big.circuit_wire_max_distance = nil

  data:extend({big})
end

do
  -- Lamp mini helper: shallow-copies big-lamp and rescales sprite by sprite_scale.
  -- Light radius stays fixed at size=60; only size, collision, and power change.
  local function make_lamp_mini(mini_name, tile_size, collision_r, energy_str, sprite_scale)
    local base = data.raw["lamp"]["big-lamp"]
    local mini = {}
    for k, v in pairs(base) do mini[k] = v end
    mini.name             = mini_name
    mini.localised_name   = nil
    mini.localised_description = nil
    mini.tile_width       = tile_size
    mini.tile_height      = tile_size
    mini.collision_box    = {{-collision_r, -collision_r}, {collision_r, collision_r}}
    mini.selection_box    = {{-tile_size/2, -tile_size/2}, {tile_size/2, tile_size/2}}
    mini.minable          = {mining_time = 0.5, result = mini_name}
    mini.energy_usage_per_tick = energy_str
    local s = sprite_scale
    mini.picture_off = {
      layers = {
        {
          filename = "__base__/graphics/entity/small-lamp/lamp.png",
          priority = "high", width = 83, height = 70,
          shift = util.by_pixel(0.25 * s, 3 * s), scale = 0.5 * s,
        },
        {
          filename = "__base__/graphics/entity/small-lamp/lamp-shadow.png",
          priority = "high", width = 76, height = 47,
          shift = util.by_pixel(4 * s, 4.75 * s), draw_as_shadow = true, scale = 0.5 * s,
        },
      },
    }
    mini.picture_on = {
      filename = "__base__/graphics/entity/small-lamp/lamp-light.png",
      priority = "high", width = 90, height = 78,
      shift = util.by_pixel(0, -7 * s), scale = 0.5 * s,
    }
    return mini
  end

  data:extend({
    -- 5×5 → 3×3 (+50% power)
    make_lamp_mini("big-lamp-mini1", 3, 1.1, "37.5kW", 3),
    -- 5×5 → 1×1 (+100% power)
    make_lamp_mini("big-lamp-mini2", 1, 0.15, "50kW", 1),
  })
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
  -- MTF minis: rescale the MTF's already-4×-scaled graphics by tile_size/12 to reach the
  -- correct visual size. Crafting speed intentionally decreases (smaller = slower research).
  local mtf = data.raw["assembling-machine"]["miniaturization-testing-facility"]
  local function make_mtf_mini(mini_name, tile_size, speed)
    local mini = {}
    for k, v in pairs(mtf) do mini[k] = v end
    mini.name             = mini_name
    mini.localised_name   = nil
    mini.localised_description = nil
    mini.tile_width       = tile_size
    mini.tile_height      = tile_size
    mini.collision_box    = {{-(tile_size/2 - 0.3), -(tile_size/2 - 0.3)},
                             { (tile_size/2 - 0.3),  (tile_size/2 - 0.3)}}
    mini.selection_box    = {{-tile_size/2, -tile_size/2}, {tile_size/2, tile_size/2}}
    mini.drawing_box                    = nil
    mini.drawing_box_vertical_extension = nil
    mini.crafting_speed   = speed
    mini.minable          = {mining_time = 1.0, result = mini_name}
    if mtf.graphics_set then
      mini.graphics_set = rescale_gs(mtf.graphics_set, tile_size / 12)
    end
    return mini
  end

  data:extend({
    make_mtf_mini("miniaturization-testing-facility-mini1", 8, 18),
    make_mtf_mini("miniaturization-testing-facility-mini2", 4, 16),
  })
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

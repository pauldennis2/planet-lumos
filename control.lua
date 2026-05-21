-- Runtime control script for Planet Lumos

local SHADOW_GEN_NAMES = {
  "shadow-generator",
  "shadow-generator-mini1",
  "shadow-generator-mini2",
}
local SHADOW_GEN_SET = {}
for _, n in ipairs(SHADOW_GEN_NAMES) do SHADOW_GEN_SET[n] = true end

-- Base power in watts per variant; quality multiplier applied at runtime.
local SHADOW_GEN_BASE_POWER = {
  ["shadow-generator"]       = 160000,
  ["shadow-generator-mini1"] = 150000,
  ["shadow-generator-mini2"] = 140000,
}
local QUALITY_POWER_MULT = {
  normal    = 1.0,
  uncommon  = 1.3,
  rare      = 1.6,
  epic      = 1.9,
  legendary = 2.5,
}
local LAMP_NAMES      = {"big-lamp", "big-lamp-mini1", "big-lamp-mini2"}
local WELL_LIT_RADIUS = 15  -- normal quality baseline

-- Quality → well-lit scan radius (tiles). Must match companion lamp light sizes.
local LAMP_WELL_LIT_RADIUS = {
  normal    = 15,
  uncommon  = 21,
  rare      = 26,
  epic      = 32,
  legendary = 37.5,
}

-- Quality → invisible companion lamp entity spawned at the same position.
-- The companion's prototype light.size extends the visual radius beyond the base lamp.
local QUALITY_COMPANION = {
  uncommon  = "lumos-light-uncommon",
  rare      = "lumos-light-rare",
  epic      = "lumos-light-epic",
  legendary = "lumos-light-legendary",
}

-- ── Permadark helpers ─────────────────────────────────────────────────────────

local function lock_lumos_midnight(surface)
  surface.freeze_daytime = false
  surface.daytime = 0.5
  surface.freeze_daytime = true
  surface.show_clouds = false
  surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
  surface.min_brightness = 0
end

-- ── Shadow-generator quality scaling ─────────────────────────────────────────

local function apply_shadow_gen_quality(entity)
  local base = SHADOW_GEN_BASE_POWER[entity.name]
  if not base then return end
  local quality = entity.quality and entity.quality.name or "normal"
  entity.energy_production = base * (QUALITY_POWER_MULT[quality] or 1.0)
end

-- ── Quality companion helpers ─────────────────────────────────────────────────

local function spawn_quality_companion(entity)
  local quality = entity.quality and entity.quality.name or "normal"
  local companion_name = QUALITY_COMPANION[quality]
  if not companion_name then return end
  local companion = entity.surface.create_entity({
    name     = companion_name,
    position = entity.position,
    force    = "neutral",
  })
  if companion then
    storage.quality_companions[entity.unit_number] = companion
  end
end

local function remove_quality_companion(unit_number)
  local companion = storage.quality_companions[unit_number]
  if companion and companion.valid then companion.destroy() end
  storage.quality_companions[unit_number] = nil
end

-- ── Shadow-generator registry ─────────────────────────────────────────────────

local function register_gen(entity)
  storage.shadow_generators[entity.unit_number] = entity
end

local function unregister_gen(entity)
  storage.shadow_generators[entity.unit_number] = nil
end

-- ── Building well-lit tracking ────────────────────────────────────────────────
-- UPS strategy: lamp-centric scan, not building-centric.
-- Each tick-60 pass: for every registered lamp, find_entities_filtered within
-- WELL_LIT_RADIUS and mark those buildings "lit". Then sweep all buildings:
-- lit → hide marker, unlit → show marker. Scales with lamp count, not building count.

local function is_building_exempt(name)
  -- Shadow generators are NOT exempt: tracked for well-lit detection
  -- but with reverse behavior (active when dark, no warning marker).
  for _, n in ipairs(LAMP_NAMES) do
    if n == name then return true end
  end
  return false
end

local function show_unlit_marker(entity)
  local un = entity.unit_number
  if storage.building_markers[un] then return end
  storage.building_markers[un] = rendering.draw_sprite{
    sprite  = "item/small-lamp",
    tint    = {r = 1, g = 0.55, b = 0, a = 1},
    surface = entity.surface,
    target  = entity,
    x_scale = 0.6,
    y_scale = 0.6,
  }
end

local function hide_unlit_marker(unit_number)
  local obj = storage.building_markers[unit_number]
  if obj and obj.valid then obj.destroy() end
  storage.building_markers[unit_number] = nil
end

local function register_lumos_lamp(entity)
  storage.lumos_lamps[entity.unit_number] = entity
end

local function unregister_lumos_lamp(unit_number)
  storage.lumos_lamps[unit_number] = nil
end

local function register_building(entity)
  if entity.surface.name ~= "lumos" then return end
  if is_building_exempt(entity.name) then return end
  storage.lumos_buildings[entity.unit_number] = entity
end

local function unregister_building(unit_number)
  hide_unlit_marker(unit_number)
  storage.lumos_buildings[unit_number] = nil
end

local function is_big_lamp(name)
  for _, n in ipairs(LAMP_NAMES) do
    if n == name then return true end
  end
  return false
end

-- ── Init / config-changed ─────────────────────────────────────────────────────

script.on_init(function()
  storage.shadow_generators  = {}
  storage.quality_companions = {}
  storage.lumos_lamps        = {}
  storage.lumos_buildings    = {}
  storage.building_markers   = {}
end)

script.on_configuration_changed(function()
  storage.shadow_generators = storage.shadow_generators or {}

  -- Clean up old rendering.draw_light approach if migrating from an earlier version.
  if storage.lamp_quality_lights then
    for _, obj in pairs(storage.lamp_quality_lights) do
      if obj and obj.valid then obj.destroy() end
    end
    storage.lamp_quality_lights = nil
  end

  -- Flush and rebuild companion/lamp/building/marker state cleanly.
  if storage.quality_companions then
    for _, companion in pairs(storage.quality_companions) do
      if companion and companion.valid then companion.destroy() end
    end
  end
  storage.quality_companions = {}

  if storage.building_markers then
    for _, obj in pairs(storage.building_markers) do
      if obj and obj.valid then obj.destroy() end
    end
  end
  storage.lumos_lamps      = {}
  storage.lumos_buildings  = {}
  storage.building_markers = {}

  for _, surface in pairs(game.surfaces) do
    if surface.name == "lumos" then
      lock_lumos_midnight(surface)
    end

    for _, gen in ipairs(surface.find_entities_filtered({name = SHADOW_GEN_NAMES})) do
      storage.shadow_generators[gen.unit_number] = gen
      apply_shadow_gen_quality(gen)
    end

    for _, lamp in ipairs(surface.find_entities_filtered({name = LAMP_NAMES})) do
      spawn_quality_companion(lamp)
      if surface.name == "lumos" then
        register_lumos_lamp(lamp)
      end
    end

    if surface.name == "lumos" then
      for _, entity in ipairs(surface.find_entities_filtered({force = "player"})) do
        if entity.unit_number
           and entity.type ~= "character"
           and not is_building_exempt(entity.name)
        then
          storage.lumos_buildings[entity.unit_number] = entity
        end
      end
    end
  end
end)

-- ── Build / remove events ─────────────────────────────────────────────────────

local function on_built(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if SHADOW_GEN_SET[entity.name] then
    register_gen(entity)
    apply_shadow_gen_quality(entity)
  end
  if is_big_lamp(entity.name) then
    spawn_quality_companion(entity)
    register_lumos_lamp(entity)
  end
  register_building(entity)
end

local function on_removed(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if SHADOW_GEN_SET[entity.name] then
    unregister_gen(entity)
  end
  if is_big_lamp(entity.name) then
    remove_quality_companion(entity.unit_number)
    unregister_lumos_lamp(entity.unit_number)
  end
  unregister_building(entity.unit_number)
end

script.on_event(defines.events.on_built_entity,          on_built)
script.on_event(defines.events.on_robot_built_entity,    on_built)
script.on_event(defines.events.script_raised_built,      on_built)

script.on_event(defines.events.on_entity_died,           on_removed)
script.on_event(defines.events.on_pre_player_mined_item, on_removed)
script.on_event(defines.events.on_robot_pre_mined,       on_removed)
script.on_event(defines.events.script_raised_destroy,    on_removed)

-- ── Periodic: well-lit scan (60 ticks = 1 second) ────────────────────────────
-- Building-centric: for each building, check every lamp's farthest-corner distance.
-- A building is "fully lit" only when its entire collision box fits inside a lamp radius.
-- Uses squared distances to avoid sqrt; O(buildings × lamps) per second.

script.on_nth_tick(60, function()
  -- Snapshot lamp positions and squared radii for this tick.
  local lamp_list = {}
  for unit_number, lamp in pairs(storage.lumos_lamps or {}) do
    if not lamp.valid then
      storage.lumos_lamps[unit_number] = nil
    else
      local quality = lamp.quality and lamp.quality.name or "normal"
      local r = LAMP_WELL_LIT_RADIUS[quality] or WELL_LIT_RADIUS
      lamp_list[#lamp_list + 1] = {pos = lamp.position, r2 = r * r}
    end
  end

  -- True if the entity's entire collision box lies within at least one lamp's circle.
  local function is_fully_lit(entity)
    local pos = entity.position
    local cb  = entity.prototype.collision_box
    local hw  = math.max(math.abs(cb.left_top.x),  math.abs(cb.right_bottom.x))
    local hh  = math.max(math.abs(cb.left_top.y),  math.abs(cb.right_bottom.y))
    for _, lamp in ipairs(lamp_list) do
      local dx = math.abs(pos.x - lamp.pos.x) + hw
      local dy = math.abs(pos.y - lamp.pos.y) + hh
      if dx * dx + dy * dy <= lamp.r2 then return true end
    end
    return false
  end

  for unit_number, entity in pairs(storage.lumos_buildings or {}) do
    if not entity.valid then
      unregister_building(unit_number)
    elseif is_fully_lit(entity) then
      hide_unlit_marker(unit_number)
      entity.active = true
    else
      show_unlit_marker(entity)
      entity.active = false
    end
  end

  for unit_number, entity in pairs(storage.shadow_generators or {}) do
    if not entity.valid then
      storage.shadow_generators[unit_number] = nil
    else
      entity.active = not is_fully_lit(entity)
    end
  end
end)

-- ── Lock midnight on initial surface creation ─────────────────────────────────

script.on_event(defines.events.on_surface_created, function(event)
  local surface = game.get_surface(event.surface_index)
  if surface and surface.name == "lumos" then
    lock_lumos_midnight(surface)
  end
end)

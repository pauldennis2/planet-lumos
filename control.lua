-- Runtime control script for Planet Lumos

local SHADOW_GEN = "shadow-generator"
local LAMP_NAMES = {"big-lamp", "big-lamp-mini1", "big-lamp-mini2"}
local WELL_LIT_RADIUS = 15  -- matches big-lamp light radius

-- ── Shadow-generator registry ────────────────────────────────────────────────

local function register(entity)
  storage.shadow_generators[entity.unit_number] = entity
end

local function unregister(entity)
  storage.shadow_generators[entity.unit_number] = nil
end

local function scan_surface_for_generators(surface)
  local gens = surface.find_entities_filtered({name = SHADOW_GEN})
  for _, gen in ipairs(gens) do
    storage.shadow_generators[gen.unit_number] = gen
  end
end

script.on_init(function()
  storage.shadow_generators = {}
end)

-- Re-scan all surfaces when mod is added or updated, picking up any existing generators.
script.on_configuration_changed(function()
  storage.shadow_generators = storage.shadow_generators or {}
  for _, surface in pairs(game.surfaces) do
    scan_surface_for_generators(surface)
  end
end)

local function on_built(event)
  local entity = event.entity
  if entity and entity.valid and entity.name == SHADOW_GEN then
    register(entity)
  end
end

local function on_removed(event)
  local entity = event.entity
  if entity and entity.valid and entity.name == SHADOW_GEN then
    unregister(entity)
  end
end

script.on_event(defines.events.on_built_entity,        on_built)
script.on_event(defines.events.on_robot_built_entity,  on_built)
script.on_event(defines.events.script_raised_built,    on_built)

script.on_event(defines.events.on_entity_died,         on_removed)
script.on_event(defines.events.on_pre_player_mined_item, on_removed)
script.on_event(defines.events.on_robot_pre_mined,     on_removed)
script.on_event(defines.events.script_raised_destroy,  on_removed)

-- ── Periodic update (60 ticks = 1 second) ───────────────────────────────────
-- 1. Lock Lumos to midnight regardless of /cheat or other overrides.
-- 2. Toggle each shadow generator: active when dark, inactive when well-lit.

script.on_nth_tick(60, function()
  -- Permadark: force Lumos surface to midnight every second.
  local lumos = game.get_surface("lumos")
  if lumos then lumos.daytime = 0.75 end

  -- Shadow generator well-lit check.
  if not storage.shadow_generators then return end
  for unit_number, entity in pairs(storage.shadow_generators) do
    if not entity.valid then
      storage.shadow_generators[unit_number] = nil
    else
      local lamps = entity.surface.find_entities_filtered({
        name     = LAMP_NAMES,
        position = entity.position,
        radius   = WELL_LIT_RADIUS,
      })
      entity.active = (#lamps == 0)
    end
  end
end)

-- Keep daytime locked on initial surface creation too.
script.on_event(defines.events.on_surface_created, function(event)
  local surface = game.get_surface(event.surface_index)
  if surface and surface.name == "lumos" then
    surface.daytime = 0.75
  end
end)

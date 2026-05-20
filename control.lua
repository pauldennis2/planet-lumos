-- Runtime control script for Planet Lumos

-- Initialize lumos surface to midnight when first created.
-- The day-night cycle is set to ~138 real days, so daytime barely advances,
-- but we lock the starting position to midnight (0.75) so it's dark from the first visit.
script.on_event(defines.events.on_surface_created, function(event)
  local surface = game.get_surface(event.surface_index)
  if surface and surface.name == "lumos" then
    surface.daytime = 0.75
  end
end)

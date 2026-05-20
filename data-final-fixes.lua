-- Prevent small-lamp (and any mod-added lamp type entities) from being placed on Lumos.
-- surface_conditions entries use AND logic: all must pass. Adding {property="lumos-surface", max=0}
-- means the property must be ≤ 0, which fails on Lumos (where it equals 1).
local lamp = data.raw["lamp"]["small-lamp"]
if lamp then
  lamp.surface_conditions = lamp.surface_conditions or {}
  table.insert(lamp.surface_conditions, {property = "lumos-surface", max = 0})
end

-- Runs after all mods, so catches every lab regardless of load order.
-- Guard against shared input tables (shallow-copied labs would get duplicate entries).
for _, lab in pairs(data.raw["lab"]) do
  local already_has = false
  for _, input in ipairs(lab.inputs) do
    if input == "lumos-science-pack" then
      already_has = true
      break
    end
  end
  if not already_has then
    table.insert(lab.inputs, "lumos-science-pack")
  end
end

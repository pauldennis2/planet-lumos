-- Block standard small lamps on Lumos. Big lamps are built for it; small lamps are not.
-- Done in final-fixes so entity.lua's big-lamp copy (from small-lamp) already exists
-- and won't inherit this restriction.
data.raw["lamp"]["small-lamp"].surface_conditions = {{property = "lumos-surface", max = 0}}

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

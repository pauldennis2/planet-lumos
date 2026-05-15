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

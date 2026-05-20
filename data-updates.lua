-- Data updates for Planet Lumos

if not mods["bobassembly"] then
  table.insert(data.raw["technology"]["lumoplating"].effects,
    {type = "unlock-recipe", recipe = "assembler-miniaturization-data"})
  table.insert(data.raw["technology"]["assembler-miniaturization-1"].unit.ingredients,
    {"assembler-miniaturization-data", 1})
end

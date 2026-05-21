data:extend({
  {
    type = "fluid",
    name = "liquid-light",
    default_temperature = 25,
    max_temperature = 100,
    heat_capacity = "0.1kJ",
    base_color = {r = 1.0, g = 0.9, b = 0.2},
    flow_color = {r = 1.0, g = 1.0, b = 0.5},
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    order = "a[liquid-light]",
    subgroup = "fluid",
    auto_barrel = false,
  },
})

data:extend({
  {
    type = "item",
    name = "big-lamp-mini1",
    icon = "__base__/graphics/icons/small-lamp.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "b[lamp]-c[big-lamp-mini1]",
    stack_size = 20,
    place_result = "big-lamp-mini1",
  },
  {
    type = "item",
    name = "big-lamp-mini2",
    icon = "__base__/graphics/icons/small-lamp.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "b[lamp]-d[big-lamp-mini2]",
    stack_size = 20,
    place_result = "big-lamp-mini2",
  },
})

data:extend({
  {
    type = "item",
    name = "big-lamp",
    icon = "__base__/graphics/icons/small-lamp.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "b[lamp]-b[big-lamp]",
    stack_size = 20,
    place_result = "big-lamp",
  },
})

data:extend({
  -- Lumite ore (placeholder icon: iron ore)
  {
    type = "item",
    name = "lumite",
    icon = "__base__/graphics/icons/iron-ore.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "z[lumite]",
    stack_size = 50,
  },

  -- Foundry Mini1 item (placeholder: inherits foundry icon)
  -- place_result links to the entity defined in entity.lua.
})

local function make_mini_item(base_name, mini_name)
  local item = table.deepcopy(data.raw["item"][base_name])
  item.name                  = mini_name
  item.localised_name        = nil
  item.localised_description = nil
  item.place_result          = mini_name
  return item
end

data:extend({
  make_mini_item("foundry",               "foundry-mini1"),
  make_mini_item("foundry",               "foundry-mini2"),
  make_mini_item("electromagnetic-plant", "em-plant-mini1"),
  make_mini_item("chemical-plant",        "chem-plant-mini1"),
})

if not mods["bobassembly"] then
  data:extend({make_mini_item("assembling-machine-3", "assembler-mini1")})
end

if mods["bobassembly"] and data.raw["item"]["bob-assembling-machine-6"] then
  data:extend({make_mini_item("bob-assembling-machine-6", "bob-am6-mini1")})
end

if mods["bobassembly"] and data.raw["item"]["bob-chemical-plant-4"] then
  data:extend({make_mini_item("bob-chemical-plant-4", "bob-chem4-mini1")})
end

data:extend({
  make_mini_item("assembling-machine-3", "miniaturization-testing-facility"),
  make_mini_item("assembling-machine-3", "miniaturization-testing-facility-mini1"),
  make_mini_item("assembling-machine-3", "miniaturization-testing-facility-mini2"),
  make_mini_item("lab",                  "miniaturization-research-facility"),
  {
    type = "tool",
    name = "foundry-miniaturization-data",
    icon = "__base__/graphics/icons/production-science-pack.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[foundry-miniaturization-data]",
    stack_size = 200,
    durability = 1,
    durability_description_key = "science-pack-remaining-research",
  },
  {
    type = "tool",
    name = "em-plant-miniaturization-data",
    icon = "__base__/graphics/icons/utility-science-pack.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[em-plant-miniaturization-data]",
    stack_size = 200,
    durability = 1,
    durability_description_key = "science-pack-remaining-research",
  },
})

if not mods["bobassembly"] then
  data:extend({
    {
      type = "tool",
      name = "assembler-miniaturization-data",
      icon = "__base__/graphics/icons/logistic-science-pack.png",
      icon_size = 64,
      subgroup = "intermediate-product",
      order = "z[assembler-miniaturization-data]",
      stack_size = 200,
      durability = 1,
      durability_description_key = "science-pack-remaining-research",
    },
  })
end

data:extend({
  {
    type = "item",
    name = "shadow-generator",
    icon = "__base__/graphics/icons/solar-panel.png",
    icon_size = 64,
    subgroup = "energy",
    order = "f[shadow-generator]-a",
    stack_size = 10,
    place_result = "shadow-generator",
  },
  {
    type = "item",
    name = "shadow-generator-mini1",
    icon = "__base__/graphics/icons/solar-panel.png",
    icon_size = 64,
    subgroup = "energy",
    order = "f[shadow-generator]-b",
    stack_size = 10,
    place_result = "shadow-generator-mini1",
  },
  {
    type = "item",
    name = "shadow-generator-mini2",
    icon = "__base__/graphics/icons/solar-panel.png",
    icon_size = 64,
    subgroup = "energy",
    order = "f[shadow-generator]-c",
    stack_size = 10,
    place_result = "shadow-generator-mini2",
  },
})

data:extend({
  -- Lumoplate (placeholder icon: iron plate)
  {
    type = "item",
    name = "lumoplate",
    icon = "__base__/graphics/icons/iron-plate.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lumoplate]",
    stack_size = 100,
  },

  -- Lumos science pack (placeholder icon: automation science pack)
  {
    type = "tool",
    name = "lumos-science-pack",
    icon = "__base__/graphics/icons/automation-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    order = "z[lumos-science-pack]",
    stack_size = 200,
    durability = 1,
    durability_description_key = "science-pack-remaining-research",
  },
})

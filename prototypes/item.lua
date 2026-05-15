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
  make_mini_item("assembling-machine-3",  "assembler-mini1"),
  make_mini_item("electromagnetic-plant", "em-plant-mini1"),
  make_mini_item("cryogenic-plant",       "cryo-plant-mini1"),
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

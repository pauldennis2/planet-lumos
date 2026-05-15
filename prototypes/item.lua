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

local foundry_item = table.deepcopy(data.raw["item"]["foundry"])
foundry_item.name               = "foundry-mini1"
foundry_item.localised_name     = nil
foundry_item.localised_description = nil
foundry_item.place_result       = "foundry-mini1"
data:extend({foundry_item})

data:extend({
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

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

data:extend({
  {
    type = "recipe",
    name = "foundry-mini1",
    enabled = false,         -- unlocked by foundry-miniaturization-1
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "foundry", amount = 1},
      {type = "item", name = "lumite",  amount = 5},
    },
    results = {
      {type = "item", name = "foundry-mini1", amount = 1},
    },
  },

  {
    type = "recipe",
    name = "lumos-science-pack",
    enabled = false,  -- unlocked by planet-discovery-lumos
    category = "crafting",
    energy_required = 1,
    ingredients = {
      {type = "item", name = "lumite", amount = 1},
    },
    results = {
      {type = "item", name = "lumos-science-pack", amount = 1},
    },
  },
})

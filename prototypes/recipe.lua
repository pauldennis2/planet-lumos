data:extend({
  {
    type = "recipe",
    name = "foundry-mini1",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "foundry", amount = 1},
      {type = "item", name = "lumite",  amount = 5},
    },
    results = {{type = "item", name = "foundry-mini1", amount = 1}},
  },
  {
    type = "recipe",
    name = "foundry-mini2",
    enabled = false,
    category = "crafting",
    energy_required = 15,
    ingredients = {
      {type = "item", name = "foundry-mini1", amount = 1},
      {type = "item", name = "lumoplate",     amount = 10},
    },
    results = {{type = "item", name = "foundry-mini2", amount = 1}},
  },
  {
    type = "recipe",
    name = "assembler-mini1",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "assembling-machine-3", amount = 1},
      {type = "item", name = "lumite",               amount = 5},
    },
    results = {{type = "item", name = "assembler-mini1", amount = 1}},
  },
  {
    type = "recipe",
    name = "em-plant-mini1",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "electromagnetic-plant", amount = 1},
      {type = "item", name = "lumite",                amount = 5},
    },
    results = {{type = "item", name = "em-plant-mini1", amount = 1}},
  },
  {
    type = "recipe",
    name = "cryo-plant-mini1",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "cryogenic-plant", amount = 1},
      {type = "item", name = "lumite",          amount = 5},
    },
    results = {{type = "item", name = "cryo-plant-mini1", amount = 1}},
  },

  {
    type = "recipe",
    name = "lumoplate",
    enabled = false,
    category = "metallurgy",
    energy_required = 1,
    ingredients = {
      {type = "item", name = "lumite", amount = 1},
    },
    results = {{type = "item", name = "lumoplate", amount = 1}},
  },

  {
    type = "recipe",
    name = "lumos-science-pack",
    enabled = false,
    category = "crafting",
    energy_required = 1,
    ingredients = {
      {type = "item", name = "lumite", amount = 1},
    },
    results = {{type = "item", name = "lumos-science-pack", amount = 1}},
  },
})

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-assembling-machine-6"] then
  data:extend({
    {
      type = "recipe",
      name = "bob-am6-mini1",
      enabled = false,
      category = "crafting",
      energy_required = 10,
      ingredients = {
        {type = "item", name = "bob-assembling-machine-6", amount = 1},
        {type = "item", name = "lumite",                   amount = 5},
      },
      results = {{type = "item", name = "bob-am6-mini1", amount = 1}},
    },
  })
end

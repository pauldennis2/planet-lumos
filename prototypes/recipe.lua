data:extend({{type = "recipe-category", name = "miniaturization"}})

data:extend({
  {
    type = "recipe",
    name = "big-lamp",
    enabled = false,
    energy_required = 5,
    ingredients = {
      {type = "item", name = "small-lamp",  amount = 5},
      {type = "item", name = "iron-plate",  amount = 10},
      {type = "item", name = "lumoplate",   amount = 2},
    },
    results = {{type = "item", name = "big-lamp", amount = 1}},
  },
  {
    type = "recipe",
    name = "big-lamp-mini1",
    enabled = false,
    category = "miniaturization",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "big-lamp",  amount = 1},
      {type = "item", name = "lumoplate", amount = 5},
    },
    results = {{type = "item", name = "big-lamp-mini1", amount = 1}},
  },
  {
    type = "recipe",
    name = "big-lamp-mini2",
    enabled = false,
    category = "miniaturization",
    energy_required = 20,
    ingredients = {
      {type = "item", name = "big-lamp-mini1", amount = 1},
      {type = "item", name = "lumoplate",      amount = 10},
    },
    results = {{type = "item", name = "big-lamp-mini2", amount = 1}},
  },
  {
    type = "recipe",
    name = "miniaturization-testing-facility-mini1",
    enabled = false,
    category = "miniaturization",
    energy_required = 60,
    ingredients = {
      {type = "item", name = "miniaturization-testing-facility", amount = 1},
      {type = "item", name = "lumoplate",                        amount = 20},
      {type = "item", name = "steel-plate",                      amount = 10},
    },
    results = {{type = "item", name = "miniaturization-testing-facility-mini1", amount = 1}},
  },
  {
    type = "recipe",
    name = "miniaturization-testing-facility-mini2",
    enabled = false,
    category = "miniaturization",
    energy_required = 120,
    ingredients = {
      {type = "item", name = "miniaturization-testing-facility-mini1", amount = 1},
      {type = "item", name = "lumoplate",                              amount = 40},
      {type = "item", name = "steel-plate",                            amount = 20},
    },
    results = {{type = "item", name = "miniaturization-testing-facility-mini2", amount = 1}},
  },
})

data:extend({
  {
    type = "recipe",
    name = "foundry-mini1",
    enabled = false,
    category = "miniaturization",
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
    category = "miniaturization",
    energy_required = 15,
    ingredients = {
      {type = "item", name = "foundry-mini1", amount = 1},
      {type = "item", name = "lumoplate",     amount = 10},
    },
    results = {{type = "item", name = "foundry-mini2", amount = 1}},
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
    name = "chem-plant-mini1",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "chemical-plant", amount = 1},
      {type = "item", name = "lumite",         amount = 5},
    },
    results = {{type = "item", name = "chem-plant-mini1", amount = 1}},
  },
})

if not mods["bobassembly"] then
  data:extend({
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
  })
end

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

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-chemical-plant-4"] then
  data:extend({
    {
      type = "recipe",
      name = "bob-chem4-mini1",
      enabled = false,
      category = "crafting",
      energy_required = 10,
      ingredients = {
        {type = "item", name = "bob-chemical-plant-4", amount = 1},
        {type = "item", name = "lumite",               amount = 5},
      },
      results = {{type = "item", name = "bob-chem4-mini1", amount = 1}},
    },
  })
end

data:extend({
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
    energy_required = 20,
    ingredients = {
      {type = "item", name = "lumite", amount = 50},
    },
    results = {{type = "item", name = "lumos-science-pack", amount = 1}},
  },
})

data:extend({
  {
    type = "recipe",
    name = "miniaturization-testing-facility",
    enabled = false,
    category = "crafting",
    energy_required = 30,
    ingredients = {
      {type = "item", name = "assembling-machine-3", amount = 1},
      {type = "item", name = "steel-plate",          amount = 20},
      {type = "item", name = "processing-unit",      amount = 10},
      {type = "item", name = "lumoplate",            amount = 20},
    },
    results = {{type = "item", name = "miniaturization-testing-facility", amount = 1}},
  },
  {
    type = "recipe",
    name = "miniaturization-research-facility",
    enabled = false,
    category = "crafting",
    energy_required = 10,
    ingredients = {
      {type = "item", name = "steel-plate", amount = 10},
      {type = "item", name = "lumoplate",   amount = 10},
    },
    results = {{type = "item", name = "miniaturization-research-facility", amount = 1}},
  },
  {
    type = "recipe",
    name = "foundry-miniaturization-data",
    enabled = false,
    category = "miniaturization",
    energy_required = 16000,
    allow_productivity = true,
    ingredients = {
      {type = "item", name = "foundry", amount = 1},
    },
    results = {{type = "item", name = "foundry-miniaturization-data", amount = 1}},
  },
  {
    type = "recipe",
    name = "em-plant-miniaturization-data",
    enabled = false,
    category = "miniaturization",
    energy_required = 16000,
    allow_productivity = true,
    ingredients = {
      {type = "item", name = "electromagnetic-plant", amount = 1},
    },
    results = {{type = "item", name = "em-plant-miniaturization-data", amount = 1}},
  },
})

if not mods["bobassembly"] then
  data:extend({
    {
      type = "recipe",
      name = "assembler-miniaturization-data",
      enabled = false,
      category = "miniaturization",
      energy_required = 16000,
      allow_productivity = true,
      ingredients = {
        {type = "item", name = "assembling-machine-3", amount = 1},
      },
      results = {{type = "item", name = "assembler-miniaturization-data", amount = 1}},
    },
  })
end


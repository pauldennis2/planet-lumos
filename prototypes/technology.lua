data:extend({
  {
    type = "technology",
    name = "planet-discovery-lumos",
    icon = "__base__/graphics/technology/space-science-pack.png",
    icon_size = 256,
    order = "e-b",
    prerequisites = {"rocket-silo"},
    unit = {
      count = 1000,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack",   1},
        {"chemical-science-pack",   1},
        {"space-science-pack",      1},
      },
      time = 60,
    },
    effects = {
      {
        type = "unlock-space-location",
        space_location = "lumos",
        use_icon_overlay_constant = true,
      },
      {
        type = "unlock-recipe",
        recipe = "lumos-science-pack",
      },
    },
  },

  {
    type = "technology",
    name = "lumoplating",
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    icon_size = 256,
    order = "e-b-a",
    prerequisites = {"planet-discovery-lumos"},
    unit = {
      count = 50,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "lumoplate"},
      {type = "unlock-recipe", recipe = "big-lamp"},
      {type = "unlock-recipe", recipe = "miniaturization-testing-facility"},
      {type = "unlock-recipe", recipe = "miniaturization-research-facility"},
      {type = "unlock-recipe", recipe = "foundry-miniaturization-data"},
      {type = "unlock-recipe", recipe = "em-plant-miniaturization-data"},
    },
  },

})

data:extend({
  {
    type = "technology",
    name = "miniaturization-1",
    icon = "__base__/graphics/technology/module.png",
    icon_size = 256,
    order = "e-c",
    prerequisites = {"planet-discovery-lumos"},
    unit = {
      count = 50,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {},
  },

  {
    type = "technology",
    name = "em-plant-miniaturization-1",
    icon = "__base__/graphics/technology/electronics.png",
    icon_size = 256,
    order = "e-f",
    prerequisites = {"miniaturization-1"},
    unit = {
      count = 10,
      ingredients = {{"lumos-science-pack", 1}, {"em-plant-miniaturization-data", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "em-plant-mini1"},
    },
  },

  {
    type = "technology",
    name = "foundry-miniaturization-1",
    icon = "__base__/graphics/technology/rocket-silo.png",
    icon_size = 256,
    order = "e-d",
    prerequisites = {"miniaturization-1"},
    unit = {
      count = 100,
      ingredients = {{"lumos-science-pack", 1}, {"foundry-miniaturization-data", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "foundry-mini1"},
    },
  },

  {
    type = "technology",
    name = "miniaturization-2",
    icon = "__base__/graphics/technology/speed-module-2.png",
    icon_size = 256,
    order = "e-h",
    prerequisites = {"miniaturization-1", "lumoplating"},
    unit = {
      count = 2000,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {},
  },

  {
    type = "technology",
    name = "foundry-miniaturization-2",
    icon = "__base__/graphics/technology/productivity-module-3.png",
    icon_size = 256,
    order = "e-i",
    prerequisites = {"miniaturization-2", "foundry-miniaturization-1"},
    unit = {
      count = 50,
      ingredients = {{"lumos-science-pack", 1}, {"foundry-miniaturization-data", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "foundry-mini2"},
    },
  },

  {
    type = "technology",
    name = "big-lamp-miniaturization-1",
    icon = "__base__/graphics/technology/electric-energy-distribution-1.png",
    icon_size = 256,
    order = "e-m",
    prerequisites = {"miniaturization-1", "lumoplating"},
    unit = {
      count = 20,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "big-lamp-mini1"},
    },
  },

  {
    type = "technology",
    name = "big-lamp-miniaturization-2",
    icon = "__base__/graphics/technology/electric-energy-distribution-2.png",
    icon_size = 256,
    order = "e-n",
    prerequisites = {"miniaturization-2", "big-lamp-miniaturization-1"},
    unit = {
      count = 50,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "big-lamp-mini2"},
    },
  },

  {
    type = "technology",
    name = "mtf-miniaturization-1",
    icon = "__base__/graphics/technology/productivity-module-2.png",
    icon_size = 256,
    order = "e-o",
    prerequisites = {"miniaturization-1", "lumoplating"},
    unit = {
      count = 50,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "miniaturization-testing-facility-mini1"},
    },
  },

  {
    type = "technology",
    name = "mtf-miniaturization-2",
    icon = "__base__/graphics/technology/productivity-module-3.png",
    icon_size = 256,
    order = "e-p",
    prerequisites = {"miniaturization-2", "mtf-miniaturization-1"},
    unit = {
      count = 200,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "miniaturization-testing-facility-mini2"},
    },
  },

  {
    type = "technology",
    name = "chem-plant-miniaturization-1",
    icon = "__base__/graphics/technology/chemical-science-pack.png",
    icon_size = 256,
    order = "e-k",
    prerequisites = {"miniaturization-1"},
    unit = {
      count = 10,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "chem-plant-mini1"},
    },
  },
})

if not mods["bobassembly"] then
  data:extend({
    {
      type = "technology",
      name = "assembler-miniaturization-1",
      icon = "__base__/graphics/technology/automation-3.png",
      icon_size = 256,
      order = "e-e",
      prerequisites = {"miniaturization-1"},
      unit = {
        count = 10,
        ingredients = {{"lumos-science-pack", 1}},
        time = 60,
      },
      effects = {
        {type = "unlock-recipe", recipe = "assembler-mini1"},
      },
    },
  })
end

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-assembling-machine-6"] then
  data:extend({
    {
      type = "technology",
      name = "bob-am6-miniaturization-1",
      icon = "__base__/graphics/technology/bulk-inserter.png",
      icon_size = 256,
      order = "e-j",
      prerequisites = {"miniaturization-1"},
      unit = {
        count = 10,
        ingredients = {{"lumos-science-pack", 1}},
        time = 60,
      },
      effects = {
        {type = "unlock-recipe", recipe = "bob-am6-mini1"},
      },
    },
  })
end

if mods["bobassembly"] and data.raw["assembling-machine"]["bob-chemical-plant-4"] then
  data:extend({
    {
      type = "technology",
      name = "bob-chem4-miniaturization-1",
      icon = "__base__/graphics/technology/chemical-science-pack.png",
      icon_size = 256,
      order = "e-l",
      prerequisites = {"chem-plant-miniaturization-1"},
      unit = {
        count = 10,
        ingredients = {{"lumos-science-pack", 1}},
        time = 60,
      },
      effects = {
        {type = "unlock-recipe", recipe = "bob-chem4-mini1"},
      },
    },
  })
end

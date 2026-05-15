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
    },
  },

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
    name = "foundry-miniaturization-1",
    icon = "__base__/graphics/technology/rocket-silo.png",
    icon_size = 256,
    order = "e-d",
    prerequisites = {"miniaturization-1"},
    unit = {
      count = 100,
      ingredients = {{"lumos-science-pack", 1}},
      time = 60,
    },
    effects = {
      {type = "unlock-recipe", recipe = "foundry-mini1"},
    },
  },
})

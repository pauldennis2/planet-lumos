data:extend({
  {
    type = "technology",
    name = "planet-discovery-lumos",
    -- Reuse a planet-discovery icon as a placeholder until we have our own art.
    icon = "__space-age__/graphics/technology/planet-discovery-vulcanus.png",
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
    },
  },
})

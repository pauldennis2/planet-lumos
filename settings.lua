data:extend({
  {
    type = "bool-setting",
    name = "planet-lumos-placeholder",
    setting_type = "startup",
    default_value = false,
    order = "a",
  },
  {
    type = "int-setting",
    name = "lumos-average-width",
    setting_type = "startup",
    default_value = 30,
    minimum_value = 10,
    maximum_value = 200,
    order = "b",
  },
  {
    type = "int-setting",
    name = "lumos-snek-number",
    setting_type = "startup",
    default_value = 3,
    minimum_value = 1,
    maximum_value = 10,
    order = "c",
  },
})

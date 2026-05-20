# Factorio 2.0 Terrain Generation Primer

## How tile placement works

Every tile prototype has an optional `autoplace` field with a `probability_expression` string. At map generation time, Factorio evaluates this expression at every tile position; **the tile with the highest positive value wins**. Tiles whose expression evaluates to ≤ 0 at a position are not placed there.

To control which tiles are even *considered* on a planet, list them explicitly in `map_gen_settings.autoplace_settings["tile"].settings`. Set `treat_missing_as_default = false` so unlisted tiles are ignored entirely.

---

## The noise expression language

Expressions are **strings** (not Lua tables). They are evaluated by Factorio's built-in noise VM, not by Lua. You build them with string formatting in data-stage Lua, embedding literal numbers computed from settings.

### Available variables (at a tile position)
| Variable | Meaning |
|---|---|
| `x`, `y` | Tile coordinates |
| `distance` | Distance from map center (0,0) |
| `map_seed` | The game's map seed (integer) |
| `elevation` | Standard elevation property (if defined) |
| `moisture`, `aux`, `temperature` | Standard climate properties |

### Key built-in functions

```
-- Continuous Perlin-style noise, single octave
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 42, input_scale = 0.01, output_scale = 1}
-- Returns roughly [-1, 1] before output_scale

-- Multi-octave version (fBm)
multioctave_noise{x = x, y = y, seed0 = map_seed, seed1 = 42,
                  octaves = 3, persistence = 0.6,
                  input_scale = 0.01, output_scale = 1}

-- Arithmetic / clamping
abs(expr)
max(a, b)
min(a, b)
clamp(expr, lo, hi)
sqrt(expr)

-- Conditionals
if(condition, then_value, else_value)

-- Trig
sin(x)   -- argument in radians
cos(x)
```

`input_scale` multiplies the x/y coordinates before sampling, so `input_scale = 1/wavelength` samples one full noise cycle per `wavelength` tiles. `output_scale` multiplies the output.

### Sampling along one axis only

To make a noise value that varies only with `x` (ignoring `y`), pass a constant for `y`:

```
basis_noise{x = x, y = 0, seed0 = map_seed, seed1 = 99, input_scale = 0.002, output_scale = 50}
```

This gives a smooth, non-repeating path through "y-space" as a function of x — useful for a snake centerline.

---

## Defining named expressions

Named expressions become global identifiers reusable in other expressions:

```lua
data:extend({
  {
    type = "noise-expression",
    name = "my_snake_mask",
    expression = "my_half_width - abs(y - my_center_y)",
    local_expressions = {
      my_center_y    = "multioctave_noise{x=x, y=0, seed0=map_seed, seed1=111, octaves=3, persistence=0.6, input_scale=0.002, output_scale=60}",
      my_half_width  = "max(5, 15 + basis_noise{x=x, y=0, seed0=map_seed, seed1=222, input_scale=0.005, output_scale=5})",
    },
  },
})
```

`local_expressions` are scoped to that expression (not global). The final `expression` field is evaluated with those locals in scope.

For reusable parameterized helpers, use `noise-function`:

```lua
{
  type = "noise-function",
  name = "my_octave_noise",
  parameters = {"seed1", "scale", "magnitude"},
  expression = "multioctave_noise{x=x, y=0, seed0=map_seed, seed1=seed1, octaves=3, persistence=0.6, input_scale=scale, output_scale=magnitude}",
}
-- Call it: "my_octave_noise(42, 0.002, 60)"
```

---

## Injecting mod settings into expressions

Startup settings are plain Lua values at data stage. Read them and embed as literals:

```lua
local avg_w  = settings.startup["lumos-average-width"].value
local snek_n = settings.startup["lumos-snek-number"].value

local amplitude = avg_w * snek_n * 0.45
local freq      = snek_n ^ 0.8 / 2000   -- higher snek → shorter wavelength

data:extend({
  {
    type = "noise-expression",
    name = "lumos_snake_mask",
    expression = string.format(
      "max(2.5, %f + basis_noise{x=x,y=0,seed0=map_seed,seed1=222,input_scale=0.005,output_scale=%f}) - abs(y - multioctave_noise{x=x,y=0,seed0=map_seed,seed1=111,octaves=3,persistence=0.6,input_scale=%f,output_scale=%f})",
      avg_w / 2, avg_w * 0.3,   -- half-width base and variation
      freq, amplitude            -- snake path frequency and amplitude
    ),
  },
})
```

---

## Custom tile prototypes

To avoid colliding with base-game autoplace, create new tile prototypes by deep-copying existing ones and assigning a Lumos-specific autoplace:

```lua
local ground = table.deepcopy(data.raw["tile"]["volcanic-soil-dark"])
ground.name = "lumos-ground"
ground.autoplace = { probability_expression = "lumos_snake_mask" }

local lava_out = table.deepcopy(data.raw["tile"]["lava"])
lava_out.name = "lumos-lava"
lava_out.autoplace = { probability_expression = "max(0, -(lumos_snake_mask))" }

data:extend({ ground, lava_out })
```

The land tile wins anywhere `lumos_snake_mask > 0`. Lava fills the rest.

---

## Planet map_gen_settings wiring

```lua
map_gen_settings = {
  autoplace_settings = {
    tile = {
      treat_missing_as_default = false,
      settings = {
        ["lumos-ground"] = {},
        ["lumos-lava"]   = {},
      },
    },
    entity    = { treat_missing_as_default = false },
    decorative= { treat_missing_as_default = false },
  },
  autoplace_controls = {
    lumite = { frequency = 1, size = 1, richness = 1 },
  },
  cliff_settings = { cliff_elevation_interval = 0 },
}
```

`property_expression_names` (e.g. `elevation = "my_elevation"`) overrides the standard properties for a planet — useful when tiles already autoplace based on elevation. For custom snake logic with dedicated tile names, it is not needed.

---

## Reference locations (as of Factorio 2.0.76)

| What | Path |
|---|---|
| Base noise expressions | `data/base/prototypes/noise-expressions.lua` |
| Nauvis map gen | `data/base/prototypes/planet/planet-map-gen.lua` |
| Vulcanus map gen | `data/space-age/prototypes/planet/planet-vulcanus-map-gen.lua` |
| Vulcanus tiles (lava, volcanic-soil-dark) | `data/space-age/prototypes/tile/tiles-vulcanus.lua` |
| Space Age map gen wrapper | `data/space-age/prototypes/planet/planet-map-gen.lua` |

All paths relative to `C:\Program Files (x86)\Steam\steamapps\common\Factorio\`.

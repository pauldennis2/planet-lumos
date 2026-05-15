local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

asteroid_util.lumos_ratio  = {3, 2, 1, 0}
asteroid_util.lumos_chunks = 0.0030
asteroid_util.lumos_medium = 0.0025

-- Nauvis → Lumos route: mirrors the nauvis_vulcanus pattern.
-- Medium asteroids start at 0 on the Nauvis side and rise toward Lumos.
asteroid_util.nauvis_lumos =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.lumos_chunks,  angle_when_stopped = asteroid_util.chunk_angle},
  },
  probability_on_range_medium =
  {
    {position = 0.1, probability = 0,                               angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.5, probability = asteroid_util.lumos_medium * 3,  angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.9, probability = asteroid_util.lumos_medium,      angle_when_stopped = asteroid_util.medium_angle},
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.nauvis_ratio},
    {position = 0.9, ratios = asteroid_util.lumos_ratio},
  },
}

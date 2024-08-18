extends Node

# SIZE CONSTANTS
# const GROW_FACTOR = 0.25
# const SNAP_GRID_PIXELS = 30
# const CONTAINER_GRID_SIZE = 24
# const CONTAINER_EDGE_SIZE = CONTAINER_GRID_SIZE * SNAP_GRID_PIXELS
# const SCREEN_WIDTH = 1920
# const SCREEN_HEIGHT = 1080
# const SCREEN_WIDTH_GRID = SCREEN_WIDTH / SNAP_GRID_PIXELS
# const SCREEN_HEIGHT_GRID = SCREEN_HEIGHT / SNAP_GRID_PIXELS

# COLOR CONSTANTS
static var GREEN: Color = Color.html("#8EA604")
static var GREEN2: Color = Color.html("#333C02")
static var BLUE: Color = Color.html("#44ccff")
static var RED: Color = Color.html("#FF3A20")
static var RED2: Color = Color.html("#520A00")
static var WHITE: Color = Color.html("#E5D4CE")
static var GRAY: Color = Color.DIM_GRAY

static var COLORS = [GREEN, GREEN2, BLUE, RED, RED2, GRAY]

func snap_to_grid(point: Vector2, snap_grid_pixels) -> Vector2i:
  return round(point / snap_grid_pixels) * snap_grid_pixels

func is_in_list(item, lst):
  for l in lst:
    if l == item:
      return true
  return false

# SHAPES (should be of size multiple of 4)
const right_triangle = [
  Vector2i(0, 0),
  Vector2i(4, 4),
  Vector2i(8, 0)]

# LEVELS
static var LEVEL1: Level = Level.create(50, 12, [right_triangle, right_triangle, right_triangle])
static var LEVEL2: Level = Level.create(40, 16, [right_triangle, right_triangle, right_triangle])
static var LEVEL3: Level = Level.create(30, 20, [right_triangle, right_triangle, right_triangle])

static var LEVELS = [LEVEL1, LEVEL2, LEVEL3]

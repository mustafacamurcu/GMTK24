extends Node

# SIZE CONSTANTS
# const GROW_FACTOR = 0.25
# const SNAP_GRID_PIXELS = 30
# const CONTAINER_GRID_SIZE = 24
const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const CONTAINER_EDGE_SIZE = 1080 * 0.8

# COLOR CONSTANTS
static var GREEN: Color = Color.html("#8EA604")
static var GREEN2: Color = Color.html("#333C02")
static var BLUE: Color = Color.html("#44ccff")
static var RED: Color = Color.html("#FF3A20")
static var RED2: Color = Color.html("#520A00")
static var WHITE: Color = Color.html("#E5D4CE")
static var GRAY: Color = Color.DIM_GRAY

static var COLORS = [GREEN, GREEN2, BLUE, RED, RED2, GRAY]

# Utility Methods

func snap_to_grid(point: Vector2, snap_grid_pixels) -> Vector2i:
  return round(point / snap_grid_pixels) * snap_grid_pixels

func is_in_list(item, lst):
  for l in lst:
    if l == item:
      return true
  return false

func polygon_area(poly) -> float:
  var sum = 0
  for i in range(poly.size()):
    var a = poly[i]
    var b = poly[(i + 1) % poly.size()]
    sum += a[0] * b[1] - a[1] * b[0]
  return abs(sum) / 2

static var right_triangle = Shape.new([
  Vector2i(0, 0),
  Vector2i(4, 4),
  Vector2i(8, 0)], BLUE)


# LEVELS

# Level 1
static var shape1 = Shape.new([[0, 0], [5, 0], [5, 8], [0, 13]], BLUE)
static var shape2 = Shape.new([[5, 0], [16, 0], [12, 4], [7, 5], [5, 5]], BLUE)
static var shape3 = Shape.new([[16, 0], [12, 4], [16, 8]], BLUE)
static var shape4 = Shape.new([[5, 5], [7, 5], [7, 10], [5, 8]], BLUE)
static var shape5 = Shape.new([[7, 5], [12, 8], [11, 10], [7, 10]], BLUE)
static var shape6 = Shape.new([[7, 10], [11, 10], [9, 12]], BLUE)
static var shape7 = Shape.new([[7, 5], [12, 4], [16, 8], [16, 16], [11, 10], [12, 8]], BLUE)
static var shape8 = Shape.new([[0, 16], [0, 13], [5, 8], [9, 12], [5, 16]], GREEN, 1, Vector2i(572, -26), 270)
static var shape9 = Shape.new([[5, 16], [11, 10], [16, 16]], GREEN2)
static var LEVEL1: Level = Level.create(32, [shape1, shape2, shape3, shape4, shape5, shape6, shape7, shape8, shape9], 1)

# Level 2
static var shape2_1 = Shape.new([[0, 0], [4, 0], [4, 1], [2, 4], [0, 4]], BLUE)
static var shape2_2 = Shape.new([[0, 4], [4, 4], [4, 5], [0, 5]], BLUE)
static var shape2_3 = Shape.new([[0, 5], [2, 5], [3, 6], [8, 6], [8, 8], [0, 8]], BLUE)
static var shape2_4 = Shape.new([[4, 0], [8, 0], [8, 6], [5, 6], [6, 5], [4, 5]], BLUE)
static var shape2_5 = Shape.new([[4, 1], [4, 4], [2, 4]], Color.YELLOW)
static var shape2_6 = Shape.new([[6, 5], [5, 6], [3, 6], [2, 5]], Color.BROWN)
static var LEVEL2: Level = Level.create(32, [shape2_1, shape2_2, shape2_3, shape2_4, shape2_5, shape2_6], 2)

static var LEVEL3: Level = Level.create(20, [right_triangle, right_triangle, right_triangle], 3)
static var LEVEL4: Level = Level.create(12, [right_triangle, right_triangle, right_triangle], 4)
static var LEVEL5: Level = Level.create(16, [right_triangle, right_triangle, right_triangle], 5)
static var LEVEL6: Level = Level.create(20, [right_triangle, right_triangle, right_triangle], 6)
static var LEVEL7: Level = Level.create(12, [right_triangle, right_triangle, right_triangle], 7)
static var LEVEL8: Level = Level.create(16, [right_triangle, right_triangle, right_triangle], 8)
static var LEVEL9: Level = Level.create(20, [right_triangle, right_triangle, right_triangle], 9)
static var LEVEL10: Level = Level.create(12, [right_triangle, right_triangle, right_triangle], 10)

static var LEVELS = [LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5, LEVEL6, LEVEL7, LEVEL8, LEVEL9, LEVEL10]

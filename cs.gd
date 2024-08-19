extends Node

# SIZE CONSTANTS
# const GROW_FACTOR = 0.25
# const SNAP_GRID_PIXELS = 30
# const CONTAINER_GRID_SIZE = 24
const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const CONTAINER_EDGE_SIZE = 1080 * 0.8

# COLOR CONSTANTS
static var GREEN1: Color = Color.html("#8EA604")
static var GREEN2: Color = Color.html("#333C02")
static var BLUE1: Color = Color.html("#44ccff")
static var BLUE2: Color = Color.BLUE
static var BLUE3: Color = Color.DARK_BLUE
static var BLUE4: Color = Color.SKY_BLUE
static var PURPLE1: Color = Color.PURPLE
static var PURPLE2: Color = Color.WEB_PURPLE
static var YELLOW1: Color = Color.YELLOW
static var RED1: Color = Color.html("#FF3A20")
static var RED2: Color = Color.html("#520A00")
static var RED3: Color = Color.RED
static var WHITE: Color = Color.html("#E5D4CE")
static var GRAY: Color = Color.DIM_GRAY

static var COLORS = [GREEN1, GREEN2, BLUE1, RED1, RED2, GRAY]

# Sound

var sfx_value = 60
var bgm_value = 60

func _ready():
  SignalBus.sfx_changed.connect(_on_sfx_changed)
  SignalBus.bgm_changed.connect(_on_bgm_changed)

func _on_sfx_changed(value):
  sfx_value = value

func _on_bgm_changed(value):
  bgm_value = value


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

# LEVELS

static var LEVEL1: Level = Level.create([
  Shape.new([[0, 0], [4, 0], [4, 2], [2, 5], [0, 5]], BLUE1, 0.5, Vector2i(31, -12), 0),
  Shape.new([[8, 3], [8, 6], [5, 6]], BLUE2, 0.75, Vector2i(30, 11), 0),
  Shape.new([[0, 5], [2, 5], [3, 6], [8, 6], [8, 8], [0, 8]], BLUE3, 0.5, Vector2i(14, 13), 0),
  Shape.new([[4, 0], [8, 0], [8, 3], [6, 5], [4, 5]], BLUE4, 0.5, Vector2i(11, -10), 0),
  Shape.new([[4, 2], [4, 5], [2, 5]], Color.YELLOW, 1, Vector2i(18, 2), 0),
  Shape.new([[6, 5], [5, 6], [3, 6], [2, 5]], RED2, 1.25, Vector2i(20, 10), 0)],
  1)


static var LEVEL2: Level = Level.create([
  Shape.new([[1, 0], [8, 0], [7, 1], [4, 3], [1, 1]], GREEN1, 0.5, Vector2i(17, -7), -90),
  Shape.new([[0, 0], [1, 0], [1, 3], [2, 4], [0, 6]], BLUE2, 0.75, Vector2i(6, -7), -180),
  Shape.new([[1, 5], [0, 6], [0, 8], [4, 8], [3, 6], [2, 6]], BLUE3, 0.75, Vector2i(22, 0), 0),
  Shape.new([[4, 8], [3, 6], [4, 4], [5, 6], [6, 6], [7, 5], [8, 5], [8, 8]], BLUE4, 0.5, Vector2i(27, 12), 0),
  Shape.new([[8, 5], [7, 5], [6, 4], [7, 3], [7, 1], [8, 0]], GREEN2, 0.5, Vector2i(30, -2), 0),
  Shape.new([[1, 1], [1, 3], [2, 4], [1, 5], [2, 6], [3, 6], [4, 4], [4, 3]], PURPLE1, 0.75, Vector2i(23, -13), 90),
  Shape.new([[7, 1], [7, 3], [6, 4], [7, 5], [6, 6], [5, 6], [4, 4], [4, 3]], PURPLE2, 0.75, Vector2i(11, 10), -90)],
  2)

static var LEVEL3: Level = Level.create([
  Shape.new([[0, 0], [3, 2], [2, 3], [0, 3]], GREEN1, 0.5, Vector2i(30, 9), 0),
  Shape.new([[0, 0], [3, 2], [4, 2], [4, 0]], BLUE2, 0.75, Vector2i(17, 14), 90),
  Shape.new([[4, 0], [4, 4], [8, 2]], BLUE3, 0.5, Vector2i(33, 10), 90),
  Shape.new([[4, 0], [8, 0], [8, 2]], BLUE4, 0.75, Vector2i(33, -17), 0),
  Shape.new([[2, 3], [3, 2], [4, 2], [4, 4]], RED2, 0.75, Vector2i(7, -5), 180),
  Shape.new([[0, 3], [2, 3], [4, 4], [2, 5], [0, 8]], YELLOW1, 1, Vector2i(19, -6), 0),
  Shape.new([[0, 8], [2, 5], [3, 6], [4, 6], [4, 8]], PURPLE2, 0.5, Vector2i(9, 13), 360),
  Shape.new([[2, 5], [3, 6], [4, 6], [4, 4]], RED1, 0.5, Vector2i(23, 0), 270),
  Shape.new([[6, 3], [7, 4], [6, 5], [4, 4]], RED3, 1, Vector2i(24, -5), 270),
  Shape.new([[8, 2], [6, 3], [7, 4], [6, 5], [8, 8]], BLUE1, 0.75, Vector2i(7, 0), 0),
  Shape.new([[4, 4], [6, 5], [8, 8], [6, 8]], BLUE3, 0.5, Vector2i(17, 8), 90),
  Shape.new([[4, 4], [4, 8], [6, 8]], BLUE1, 0.75, Vector2i(3, -17), 90)],
  3)

static var LEVELS = [LEVEL1, LEVEL2, LEVEL3, LEVEL2, LEVEL2, LEVEL2, LEVEL2, LEVEL2, LEVEL2, LEVEL2]

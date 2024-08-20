extends Node

# SIZE CONSTANTS
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
static var SNOW1: Color = Color.SNOW
static var SNOW2: Color = Color.LIGHT_BLUE
static var PURPLE1: Color = Color.PURPLE
static var PURPLE2: Color = Color.WEB_PURPLE
static var PINK1: Color = Color.DEEP_PINK
static var YELLOW1: Color = Color.YELLOW
static var YELLOW2: Color = Color.GOLD
static var YELLOW3: Color = Color.LIGHT_YELLOW
static var RED1: Color = Color.html("#FF3A20")
static var RED2: Color = Color.html("#520A00")
static var RED3: Color = Color.RED
static var WHITE1: Color = Color.html("#E5D4CE")
static var WHITE2: Color = Color.GHOST_WHITE
static var GRAY: Color = Color.DIM_GRAY

static var COLORS = [GREEN1, GREEN2, BLUE1, RED1, RED2, GRAY]

# SOUND
var sfx_value = 60
var bgm_value = 60
func _ready():
  SignalBus.sfx_changed.connect(_on_sfx_changed)
  SignalBus.bgm_changed.connect(_on_bgm_changed)
func _on_sfx_changed(value):
  sfx_value = value
func _on_bgm_changed(value):
  bgm_value = value


# UTILITY METHODS
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

static var LEVEL2: Level = Level.create([
  Shape.new([[2, 3], [3, 2], [4, 3], [5, 2], [6, 3], [6, 4], [4, 6], [2, 4]], PINK1, 0.75, Vector2i(18, -2), 0),
  Shape.new([[0, 0], [5, 0], [2, 3], [0, 3]], BLUE1, 0.75, Vector2i(11, -4), 0),
  Shape.new([[0, 3], [0, 8], [4, 8], [4, 6], [2, 4], [2, 3]], BLUE2, 0.75, Vector2i(11, 2), 0),
  Shape.new([[8, 4], [6, 4], [4, 6], [4, 8], [8, 8]], BLUE3, 0.75, Vector2i(25, 2), 0),
  Shape.new([[8, 4], [8, 0], [5, 0], [3, 2], [4, 3], [5, 2], [6, 3], [6, 4]], BLUE4, 0.75, Vector2i(22, -7), 0)],
  2)

static var LEVEL3: Level = Level.create([
  Shape.new([[0, 0], [4, 0], [4, 2], [2, 5], [0, 5]], BLUE1, 0.5, Vector2i(31, -12), 0),
  Shape.new([[8, 3], [8, 6], [5, 6]], BLUE2, 0.75, Vector2i(30, 11), 0),
  Shape.new([[0, 5], [2, 5], [3, 6], [8, 6], [8, 8], [0, 8]], BLUE3, 0.5, Vector2i(14, 13), 0),
  Shape.new([[4, 0], [8, 0], [8, 3], [6, 5], [4, 5]], BLUE4, 0.5, Vector2i(11, -10), 0),
  Shape.new([[4, 2], [4, 5], [2, 5]], Color.YELLOW, 1, Vector2i(18, 2), 0),
  Shape.new([[6, 5], [5, 6], [3, 6], [2, 5]], RED2, 1.25, Vector2i(20, 10), 0)],
  3)

static var LEVEL4: Level = Level.create([
  Shape.new([[0, 0], [3, 0], [3, 1], [2, 1], [2, 2], [0, 4]], BLUE1, 1, Vector2i(12, 3), -360),
  Shape.new([[3, 0], [8, 0], [8, 4], [7, 4], [3, 2]], BLUE3, 0.5, Vector2i(16, 6), -180),
  Shape.new([[2, 1], [3, 1], [3, 2], [2, 2]], YELLOW1, 1.75, Vector2i(4, -14), 0),
  Shape.new([[0, 4], [2, 2], [3, 2], [7, 4], [3, 5]], BLUE2, 0.5, Vector2i(13, -9), -90),
  Shape.new([[0, 4], [0, 7], [3, 5]], YELLOW2, 0.5, Vector2i(18, 5), -90),
  Shape.new([[0, 7], [0, 8], [8, 8], [8, 4], [7, 4], [3, 5]], YELLOW3, 0.75, Vector2i(24, -2), -90)],
  4)

static var LEVEL5: Level = Level.create([
  Shape.new([[0, 0], [3, 0], [1, 6], [0, 7]], BLUE1, 0.5, Vector2i(18, 10), 0),
  Shape.new([[0, 7], [0, 8], [1, 8], [3, 6], [1, 6]], SNOW2, 0.75, Vector2i(7, 3), -270),
  Shape.new([[1, 8], [3, 6], [5, 5], [7, 5], [8, 8]], SNOW1, 0.5, Vector2i(15, -13), -90),
  Shape.new([[3, 6], [2, 3], [5, 5]], BLUE2, 1.25, Vector2i(12, -18), -180),
  Shape.new([[2, 3], [1, 6], [3, 6]], GREEN2, 0.75, Vector2i(28, -10), 0),
  Shape.new([[6, 1], [5, 5], [7, 5]], GREEN1, 0.75, Vector2i(34, -8), -180),
  Shape.new([[8, 8], [8, 0], [6, 1], [7, 5]], BLUE3, 1, Vector2i(27, -6), -180),
  Shape.new([[3, 0], [8, 0], [6, 1], [5, 5], [2, 3]], BLUE4, 0.5, Vector2i(10, 1), -270)],
  5)

static var LEVEL6: Level = Level.create([
  Shape.new([[1, 0], [8, 0], [7, 1], [4, 3], [1, 1]], GREEN1, 0.5, Vector2i(17, -7), -90),
  Shape.new([[0, 0], [1, 0], [1, 3], [2, 4], [0, 6]], BLUE2, 0.75, Vector2i(6, -7), -180),
  Shape.new([[1, 5], [0, 6], [0, 8], [4, 8], [3, 6], [2, 6]], BLUE3, 0.75, Vector2i(22, 0), 0),
  Shape.new([[4, 8], [3, 6], [4, 4], [5, 6], [6, 6], [7, 5], [8, 5], [8, 8]], BLUE4, 0.5, Vector2i(27, 12), 0),
  Shape.new([[8, 5], [7, 5], [6, 4], [7, 3], [7, 1], [8, 0]], GREEN2, 0.5, Vector2i(30, -2), 0),
  Shape.new([[1, 1], [1, 3], [2, 4], [1, 5], [2, 6], [3, 6], [4, 4], [4, 3]], PURPLE1, 0.75, Vector2i(23, -13), 90),
  Shape.new([[7, 1], [7, 3], [6, 4], [7, 5], [6, 6], [5, 6], [4, 4], [4, 3]], PURPLE2, 0.75, Vector2i(11, 10), -90)],
  6)

static var LEVEL7: Level = Level.create([
  Shape.new([[0, 0], [0, 3], [2, 3], [3, 2], [4, 2], [4, 0]], GREEN1, 0.75, Vector2i(22, 9), -180),
  Shape.new([[2, 3], [3, 2], [3, 3]], YELLOW1, 2, Vector2i(7, -16), -180),
  Shape.new([[3, 3], [3, 2], [4, 2], [4, 3]], WHITE1, 1.75, Vector2i(7, 2), 0),
  Shape.new([[4, 0], [8, 0], [6, 4], [4, 3]], GREEN2, 0.5, Vector2i(25, -16), -270),
  Shape.new([[8, 0], [6, 4], [8, 6]], GREEN1, 0.5, Vector2i(27, 1), -360),
  Shape.new([[8, 6], [7, 5], [6, 6], [6, 7], [5, 7], [5, 8], [8, 8]], GREEN2, 0.75, Vector2i(20, -3), 0),
  Shape.new([[5, 6], [6, 6], [6, 7], [5, 7]], YELLOW1, 0.75, Vector2i(11, -7), -90),
  Shape.new([[5, 8], [0, 8], [0, 5], [4, 5], [5, 6]], GREEN1, 0.25, Vector2i(22, 3), 0),
  Shape.new([[0, 3], [0, 5], [4, 5], [3, 3]], GREEN2, 0.5, Vector2i(21, -10), -270),
  Shape.new([[3, 3], [4, 3], [6, 4], [7, 5], [6, 6], [5, 6], [4, 5]], WHITE2, 0.75, Vector2i(10, 6), -270)],
  7)

static var LEVEL8: Level = Level.create([
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
  8)

static var LEVELS = [LEVEL2, LEVEL3, LEVEL4, LEVEL5, LEVEL6, LEVEL7, LEVEL8]

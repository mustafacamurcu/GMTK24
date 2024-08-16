extends Node

# SIZE CONSTANTS
const GROW_FACTOR = 0.25
const SNAP_GRID_PIXELS = 50
const EDGE_SIZE_UNIT: float = SNAP_GRID_PIXELS / GROW_FACTOR
const CONTAINER_GRID_SIZE = 10
const CONTAINER_EDGE_SIZE: float = CONTAINER_GRID_SIZE * SNAP_GRID_PIXELS

# COLOR CONSTANTS
static var GREEN: Color = Color.html("#8EA604")
static var GREEN2: Color = Color.html("#333C02")
static var BLUE: Color = Color.html("#44ccff")
static var RED: Color = Color.html("#FF3A20")
static var RED2: Color = Color.html("#520A00")
static var WHITE: Color = Color.html("#E5D4CE")
static var GRAY: Color = Color.DIM_GRAY

static var COLORS = [GREEN, GREEN2, BLUE, RED, RED2, WHITE, GRAY]

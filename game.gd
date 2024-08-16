extends Node2D

# extends Node
# 
# # SIZE CONSTANTS
# const GROW_FACTOR = 0.25
# const SNAP_GRID_PIXELS = 10
# const EDGE_SIZE_UNIT = SNAP_GRID_PIXELS / GROW_FACTOR
# const CONTAINER_GRID_SIZE = 50
# const CONTAINER_EDGE_SIZE = CONTAINER_GRID_SIZE * SNAP_GRID_PIXELS

# # COLOR CONSTANTS
# static var GREEN: Color = Color.html("#8EA604")
# static var GREEN2: Color = Color.html("#333C02")
# static var BLUE: Color = Color.html("#44ccff")
# static var RED: Color = Color.html("#FF3A20")
# static var RED2: Color = Color.html("#520A00")
# static var WHITE: Color = Color.html("#E5D4CE")
# static var GRAY: Color = Color.DIM_GRAY


const PIECE = preload("res://piece.tscn")

@onready var pieces = $Pieces

var container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# for i in range(5):
	# 	var piece = PIECE.instantiate()
	# 	piece.position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
	# 	add_child(piece)
	for i in range(1):
		var piece = PIECE.instantiate()
		piece.position = Vector2(0, 0)
		add_child(piece)
	
	container = Polygon2D.new()
	container.polygon = PackedVector2Array([
		Vector2(-Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(-Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2)
	])
	container.position = Vector2(-10 * Cs.SNAP_GRID_PIXELS, 0)
	container.color = Cs.WHITE
	container.z_index = -2
	add_child(container)

func _draw() -> void:
	for i in range(-20, 20):
		for j in range(-20, 20):
			draw_circle(Vector2(i * Cs.SNAP_GRID_PIXELS, j * Cs.SNAP_GRID_PIXELS), 3, Cs.BLUE)
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


var polygon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = Polygon2D.new()
	polygon.polygon = PackedVector2Array([
		Vector2(-Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(-Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2(Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2)
	])
	polygon.color = Cs.RED
	add_child(polygon)

	for i in range(Cs.CONTAINER_GRID_SIZE + 1):
		for j in range(Cs.CONTAINER_GRID_SIZE + 1):
			var point = Polygon2D.new()
			point.polygon = PackedVector2Array([
				Vector2(0, 2),
				Vector2(0, 0),
				Vector2(2, 0),
				Vector2(2, 2),
			])
			point.color = Cs.BLUE
			point.position = Vector2(i * Cs.SNAP_GRID_PIXELS, j * Cs.SNAP_GRID_PIXELS) + Vector2(-Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2)
			add_child(point)
	var r = randi_range(0, 3)
	var side = [polygon.polygon[r], polygon.polygon[(r + 1) % 4]]
	
	var ratio = float(randi_range(1, Cs.CONTAINER_GRID_SIZE - 1)) / Cs.CONTAINER_GRID_SIZE
	
	var point = (side[0] - side[1]) * ratio + side[1]

	var side2 = [polygon.polygon[(r + 1) % 4], polygon.polygon[(r + 2) % 4]]
	
	var ratio2 = float(randi_range(0, Cs.CONTAINER_GRID_SIZE)) / Cs.CONTAINER_GRID_SIZE
	
	var point2 = (side2[0] - side2[1]) * ratio2 + side2[1]

	var line = Line2D.new()
	line.points = PackedVector2Array([point, point2])
	add_child(line)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('big'):
		polygon.scale.x += .25
		polygon.scale.y += .25
	if event.is_action_pressed('small'):
		polygon.scale.x -= .25
		polygon.scale.y -= .25

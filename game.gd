extends Node2D

const PIECE = preload("res://piece.tscn")

@onready var pieces = $Pieces
@onready var put_down_sfx = $PutDown

var container: Polygon2D
var points: Array[Vector2i]
var edges: Array[Array]
var bads: Array[Vector2i]
var adjacency: Dictionary

var level: Level

func _on_piece_picked_up(piece: Piece):
	pieces.move_child(piece, -1)

func _on_piece_put_down(_piece: Piece):
	put_down_sfx.play()

func setup(level_: Level):
	level = level_
	create_container()
	create_pieces()

func create_container():
	var grid_edge_size = level.grid_size * level.snap_grid_pixels
	container = Polygon2D.new()
	container.polygon = PackedVector2Array([
		Vector2i(0, grid_edge_size),
		Vector2i(0, 0),
		Vector2i(grid_edge_size, 0),
		Vector2i(grid_edge_size, grid_edge_size)
	])
	container.position = Vector2(-grid_edge_size / 2, -grid_edge_size / 2)
	container.color = Cs.WHITE
	add_child(container)
	container.z_index = -2
	return container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.piece_picked_up.connect(_on_piece_picked_up)
	SignalBus.piece_put_down.connect(_on_piece_put_down)

func create_pieces():
	for poly_ in level.polygons:
		var poly = poly_.duplicate()
		# translate grid points to pixel points
		for i in range(poly.size()):
			poly[i] *= level.snap_grid_pixels

		var center = Vector2i(0, 0)
		for p in poly:
			center += p
		center /= poly.size()

		var pivot = poly[0]
		for p in poly:
			if p.distance_to(center) < pivot.distance_to(center):
				pivot = p
		
		for i in range(poly.size()):
			poly[i] -= pivot
		
		var piece = PIECE.instantiate()
		pieces.add_child(piece)
		piece.position = pivot
		piece.set_polygon(PackedVector2Array(poly), level)


func get_global_container_polygon():
	var ps = PackedVector2Array()
	for p in container.polygon:
		ps.append(container.to_global(p))
	return ps

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('restart'):
		SignalBus.restart_pressed.emit()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			var pos = get_global_mouse_position()
			var label = Label.new()
			label.position = pos
			label.text = str(round(pos.x / level.snap_grid_pixels)) + ", " + str(round(pos.y / level.snap_grid_pixels))
			# label.text = str(int(pos.x)) + ", " + str(int(pos.y))
			add_child(label)

func _draw() -> void:
	# for i in range(1, level.grid_size):
	# 	for j in range(1, level.grid_size):
	# 		draw_circle(Vector2(i * level.snap_grid_pixels, j * level.snap_grid_pixels) -
	# 								Vector2(level.container_edge_size / 2, level.container_edge_size / 2), 3, Cs.BLUE)
	# for poly in polygons:
	# 	var c = Cs.COLORS.pick_random()
	# 	for edge in poly:
	# 		draw_line(edge[0], edge[1], Cs.BLUE, 3)
	# for p in points:
	# 	draw_circle(to_global(p), 3, Cs.RED)
	pass

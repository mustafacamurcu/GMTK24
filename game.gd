extends Node2D

const PIECE = preload("res://piece.tscn")

@onready var pieces = $Pieces
@onready var put_down_sfx = $PutDown
@onready var you_won = $YouWon

var container: Polygon2D
var piece_box: Polygon2D
var points: Array[Vector2i]
var edges: Array[Array]
var bads: Array[Vector2i]
var adjacency: Dictionary

var level: Level

func _on_piece_picked_up(piece: Piece):
	pieces.move_child(piece, -1)

func _on_piece_put_down(_piece: Piece):
	put_down_sfx.play()
	if check_for_win():
		win()

func win():
	you_won.show()
	SignalBus.level_completed.emit(level)

func check_for_win():
	var overlap = false
	for piece1 in pieces.get_children():
		for piece2 in pieces.get_children():
			if piece1 != piece2:
				var intersect = Geometry2D.intersect_polygons(piece1.get_global_polygon(), piece2.get_global_polygon())
				if intersect.size() != 0:
					var a = 0
					for poly in intersect:
						a += Cs.polygon_area(poly)
					if a > 1:
						overlap = true
	if overlap:
		return false
	
	# Globalize container
	var container_polygon = []
	for point in container.polygon:
		container_polygon.append(container.to_global(point))

	# Win if (Total Piece Area) == (Total Piece Area within Square) == (Square Area)
	var square_area = level.container_edge_size * level.container_edge_size

	var total_area = 0
	for piece in pieces.get_children():
		total_area += Cs.polygon_area(piece.get_global_polygon())

	var total_area_within_square = 0
	for piece in pieces.get_children():
		var intersect = Geometry2D.intersect_polygons(piece.get_global_polygon(), container_polygon)
		for poly in intersect:
			total_area_within_square += Cs.polygon_area(poly)
		
	# approx equality to prevent floating point errors
	return abs(square_area - total_area) < 1 and abs(total_area - total_area_within_square) < 1

func setup(level_: Level):
	level = level_
	create_container()
	create_pieces()
	create_piece_box()

func create_container():
	var container_edge_size = level.container_edge_size
	container = Polygon2D.new()
	container.polygon = PackedVector2Array([
		Vector2i(0, container_edge_size),
		Vector2i(0, 0),
		Vector2i(container_edge_size, 0),
		Vector2i(container_edge_size, container_edge_size)
	])
	var offset = Vector2i(-Cs.SCREEN_WIDTH / 4, 0)
	container.position = Cs.snap_to_grid(Vector2i(-container_edge_size / 2, -container_edge_size / 2) + offset, level.snap_grid_pixels)
	container.color = Cs.WHITE
	add_child(container)
	container.z_index = -2

func create_piece_box():
	var scale = 0.9
	var width = int(Cs.SCREEN_WIDTH / 2 * scale) / level.snap_grid_pixels * level.snap_grid_pixels
	var height = int(Cs.SCREEN_HEIGHT * scale) / level.snap_grid_pixels * level.snap_grid_pixels
	piece_box = Polygon2D.new()
	piece_box.polygon = PackedVector2Array([
		Vector2i(0, height),
		Vector2i(0, 0),
		Vector2i(width, 0),
		Vector2i(width, height)
	])
	var offset = Vector2(Cs.SCREEN_WIDTH / 4, 0)
	piece_box.position = Cs.snap_to_grid(Vector2(-width / 2, -height / 2) + offset, level.snap_grid_pixels)
	piece_box.color = Cs.GRAY
	add_child(piece_box)
	piece_box.z_index = -2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.piece_picked_up.connect(_on_piece_picked_up)
	SignalBus.piece_put_down.connect(_on_piece_put_down)
	SignalBus.next_level_pressed.connect(_on_next_level_pressed)

func _on_next_level_pressed():
	print("hello")
	SignalBus.level_selected.emit(Cs.LEVELS[level.number % 10])

func create_pieces():
	for shape in level.shapes:
		var poly = shape.polygon.duplicate()
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
		piece.position = shape.position
		piece.rotation_degrees = shape.rotation
		piece.scale.x = shape.scale
		piece.scale.y = shape.scale
		piece.set_polygon(PackedVector2Array(poly), level, shape.color)


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

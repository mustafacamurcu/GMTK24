extends Area2D
class_name Piece

@onready var polygon_shape: CollisionPolygon2D = $CollisionPolygon2D

var polygon

var mouse_on_me = false
var dragging = false
var dragging_spot
var picked_up_from
var rotation_pivot

var level: Level
var shape_id

var scales = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3, 4]
var small_scales = [0.25, 0.5, 0.75, 1]
var rotations = [0, 90, 180, 270]

func get_global_polygon():
	var points = []
	for point in polygon.polygon:
		points.append(to_global(point))
	return points

func set_polygon(points: PackedVector2Array, level_, c):
	level = level_
	polygon = Polygon2D.new()
	polygon.polygon = points
	polygon.color = c
	polygon.color.a = 0.7
	add_child(polygon)
	# Area2D polygon for mouse events
	polygon_shape.polygon = polygon.polygon

func shuffle():
	var s = scales.pick_random()
	var area = Cs.polygon_area(polygon.polygon)
	if area * s * s > (level.container_edge_size) * (level.container_edge_size) / 8:
		s = small_scales.pick_random()
	scale.x = s
	scale.y = s
	rotation_degrees = rotations.pick_random()

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - dragging_spot

func expand():
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	scale.x += .25
	scale.y += .25
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after

func shrink():
	if scale.x < 0.3:
		return
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	scale.x -= .25
	scale.y -= .25
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after

func rotate_in_place(deg):
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	rotation_degrees -= deg
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after

func _unhandled_key_input(event: InputEvent) -> void:
	if mouse_on_me:
		if event.is_action_pressed('big'):
			expand()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('small'):
			shrink()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('left'):
			rotate_in_place(-90)
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('right'):
			rotate_in_place(90)
			get_viewport().set_input_as_handled()
		

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if mouse_on_me:
				dragging = true
				dragging_spot = get_global_mouse_position() - global_position
				picked_up_from = position
				SignalBus.piece_picked_up.emit(self)
				get_viewport().set_input_as_handled()
		elif event.is_released():
			if dragging:
				position = Cs.snap_to_grid(position, level.snap_grid_pixels)
				SignalBus.piece_put_down.emit(self)
				dragging = false
				print(", ", str(scale.x), ", Vector2i", str(position / float(level.snap_grid_pixels)), ", ", str(rotation_degrees))
				print("shape id: ", shape_id)

func _mouse_enter() -> void:
	mouse_on_me = true

func _mouse_exit() -> void:
	mouse_on_me = false

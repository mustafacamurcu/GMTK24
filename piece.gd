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

func set_polygon(points: PackedVector2Array, level_):
	level = level_
	polygon = Polygon2D.new()
	polygon.polygon = points
	polygon.color = Cs.COLORS.pick_random()
	polygon.color.a = 0.9
	add_child(polygon)
	
	polygon_shape.polygon = polygon.polygon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# var center = Polygon2D.new()
	# center.polygon = PackedVector2Array([
	# 	Vector2(-10, 10),
	# 	Vector2(-10, -10),
	# 	Vector2(10, -10),
	# 	Vector2(10, 10)
	# ])
	# add_child(center)

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - dragging_spot

func expand():
	scale.x += .25
	scale.y += .25

func shrink(forced = false):
	if scale.x > 1.1 or forced or true:
		scale.x -= .25
		scale.y -= .25

func _unhandled_key_input(event: InputEvent) -> void:
	if mouse_on_me:
		if event.is_action_pressed('big'):
			expand()
		if event.is_action_pressed('small'):
			shrink()
		if event.is_action_pressed('left'):
			rotation_degrees -= 90
		if event.is_action_pressed('right'):
			rotation_degrees += 90
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
				SignalBus.piece_put_down.emit(self)
				position = Cs.snap_to_grid(position, level.snap_grid_pixels)
				dragging = false

func _mouse_enter() -> void:
	mouse_on_me = true

func _mouse_exit() -> void:
	mouse_on_me = false

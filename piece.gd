extends Area2D

@onready var polygon_shape: CollisionPolygon2D = $CollisionPolygon2D

var polygon

var mouse_on_me = false
var dragging = false
var dragging_spot

func set_polygon(points: PackedVector2Array):
	polygon = Polygon2D.new()
	polygon.polygon = points
	polygon.color = Cs.COLORS.pick_random()
	add_child(polygon)
	
	polygon_shape.polygon = polygon.polygon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var center = Polygon2D.new()
	center.polygon = PackedVector2Array([
		Vector2(-10, 10),
		Vector2(-10, -10),
		Vector2(10, -10),
		Vector2(10, 10)
	])
	add_child(center)

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - dragging_spot # * scale.x

func _unhandled_key_input(event: InputEvent) -> void:
	if mouse_on_me:
		if event.is_action_pressed('big'):
			scale.x += .25
			scale.y += .25
		if event.is_action_pressed('small'):
			if scale.x > 1.1:
				scale.x -= .25
				scale.y -= .25
		if event.is_action_pressed('left'):
			rotation_degrees -= 45
		if event.is_action_pressed('right'):
			rotation_degrees += 45

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if mouse_on_me:
				dragging = true
				dragging_spot = get_global_mouse_position() - global_position
				print("local_mouse: ", dragging_spot)
				print("global_mouse: ", get_global_mouse_position())
				print("global_pos: ", global_position)
		elif event.is_released():
			if dragging:
				position = round(position / Cs.SNAP_GRID_PIXELS) * Cs.SNAP_GRID_PIXELS
				dragging = false

func _mouse_enter() -> void:
	mouse_on_me = true

func _mouse_exit() -> void:
	mouse_on_me = false

extends Node2D

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

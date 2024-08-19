class_name Shape
extends Resource

static func v(poly) -> Array[Vector2i]:
  var p: Array[Vector2i] = []
  for point in poly:
    p.append(Vector2i(point[0] * 4, point[1] * 4))
  return p

var polygon: Array[Vector2i]
var color
var scale
var position
var rotation

func _init(poly, c, s = 1, p = Vector2(0, 0), r = 0):
  polygon = v(poly)
  color = c
  scale = s
  position = p
  rotation = r

func to_polygon() -> Polygon2D:
  var poly = Polygon2D.new()
  poly.polygon = polygon.duplicate()
  poly.color = color
  return poly
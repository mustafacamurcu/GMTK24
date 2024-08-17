extends Node2D

const PIECE = preload("res://piece.tscn")

var container
var points
var edges
var bads
var adjacency: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# for i in range(1):
	# 	var piece = PIECE.instantiate()
	# 	piece.position = Vector2(0, 0)
	# 	add_child(piece)
	# 	piece.set_polygon(PackedVector2Array([
	# 		Vector2(0, 0),
	# 		Vector2(0, 200),
	# 		Vector2(200, 200),
	# 		Vector2(200, 0),
	# 	]))
	
	container = Polygon2D.new()
	container.polygon = PackedVector2Array([
		Vector2i(-Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2i(-Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2i(Cs.CONTAINER_EDGE_SIZE / 2, -Cs.CONTAINER_EDGE_SIZE / 2),
		Vector2i(Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2)
	])
	container.color = Cs.WHITE
	container.z_index = -2
	add_child(container)

	setup()

func setup(N = 20):
	# TODO: maybe pick random points along the edges
	points = []
	
	adjacency = {
	}

	var corners = [
		Vector2i(container.polygon[0]),
		Vector2i(container.polygon[1]),
		Vector2i(container.polygon[2]),
		Vector2i(container.polygon[3]),
	]

	# var border_points = []
	# for i in range(-Cs.CONTAINER_GRID_SIZE / 2 + 1, Cs.CONTAINER_GRID_SIZE / 2 - 1):
	# 	var point = Vector2i(i * Cs.SNAP_GRID_PIXELS, -Cs.CONTAINER_GRID_SIZE / 2 * Cs.SNAP_GRID_PIXELS)
	# 	border_points.append(point)
	# 	point = Vector2i(i * Cs.SNAP_GRID_PIXELS, Cs.CONTAINER_GRID_SIZE / 2 * Cs.SNAP_GRID_PIXELS)
	# 	border_points.append(point)
	# 	point = Vector2i(-Cs.CONTAINER_GRID_SIZE / 2 * Cs.SNAP_GRID_PIXELS, i * Cs.SNAP_GRID_PIXELS)
	# 	border_points.append(point)
	# 	point = Vector2i(Cs.CONTAINER_GRID_SIZE / 2 * Cs.SNAP_GRID_PIXELS, i * Cs.SNAP_GRID_PIXELS)
	# 	border_points.append(point)
	
	# for i in range(6):
	# 	var point = border_points.pick_random()
	# 	points.append(point)
	# 	adjacency[point] = []
	# 	border_points.erase(point)
	
	edges = []

	for corner in corners:
		adjacency[corner] = []
		var closest_x
		var closest_x_dist
		var x_on_border = false
		var closest_y
		var closest_y_dist
		var y_on_border = false
		for other in corners:
			if corner != other and corner.x == other.x:
				closest_x = other
				closest_x_dist = corner.distance_to(other)
			if corner != other and corner.y == other.y:
				closest_y = other
				closest_y_dist = corner.distance_to(other)
		for point in points:
			if point.x == corner.x and point.distance_to(corner) < closest_x_dist:
				closest_x = point
				closest_x_dist = corner.distance_to(point)
				x_on_border = true
			if point.y == corner.y and point.distance_to(corner) < closest_y_dist:
				closest_y = point
				closest_y_dist = corner.distance_to(point)
				y_on_border = true
		adjacency[corner].append(closest_x)
		edges.append([corner, closest_x])
		adjacency[corner].append(closest_y)
		edges.append([corner, closest_y])
		if x_on_border:
			adjacency[closest_x].append(corner)
		if y_on_border:
			adjacency[closest_y].append(corner)
		
	points.append_array(corners)


	for i in range(N):
		var x = randi_range(-Cs.CONTAINER_GRID_SIZE / 2 + 3, Cs.CONTAINER_GRID_SIZE / 2 - 3)
		var y = randi_range(-Cs.CONTAINER_GRID_SIZE / 2 + 3, Cs.CONTAINER_GRID_SIZE / 2 - 3)
		var point = Vector2i(x * Cs.SNAP_GRID_PIXELS, y * Cs.SNAP_GRID_PIXELS)
		print("created point: ", point)
		var too_close = false
		for p in points:
			if point.distance_to(p) < Cs.SNAP_GRID_PIXELS * 3:
				too_close = true
				break
		if too_close:
			continue
			print("too close to another point: ", point)
			continue
		points.append(point)
		adjacency[point] = []

	bads = []

	for p: Vector2i in points:
		print("finding neighbors for: ", p)
		while adjacency[p].size() < 5:
			print("neighbor count: ", adjacency[p].size())
			var closest = p
			var closest_dist = INF
			for other: Vector2i in points:
				if (other != p
				# and adjacency[other].size() < 5
				and not is_in_list(other, adjacency[p])
				and p.distance_to(other) < closest_dist
				and no_overlap([p, other], edges)):
							closest_dist = p.distance_to(other)
							closest = other
			if closest == p:
				print('no eligible neighbor found!')
				if adjacency[p].size() < 2:
					bads.append(p)
				break
			adjacency[p].append(closest)
			adjacency[closest].append(p)
			edges.append([p, closest])
	
	print("bad points: ", bads)
	cleanup()

func cleanup():
	# remove bad (non-polygon) points
	while bads:
		var bad = bads.pop_front()
		points.erase(bad)
		print("cleaning bad:", bad)
		var to_be_removed = []
		for edge in edges:
			if edge[0] == bad or edge[1] == bad:
				print("bad edge found:", edge)
				var other
				if edge[0] == bad:
					other = edge[1]
				if edge[1] == bad:
					other = edge[0]
				to_be_removed.append(edge)
				adjacency[other].erase(bad)
				if adjacency[other].size() < 2:
					print("new bad point:", other)
					bads.append(other)
		for edge in to_be_removed:
			edges.erase(edge)

func no_overlap(line, lines):
	for edge in lines:
		var neighbors = false
		for i in range(2):
			for j in range(2):
				if line[i] == edge[j]:
					neighbors = true
					var angle = abs(rad_to_deg(Vector2(line[0] - line[1]).normalized().angle_to(Vector2(edge[0] - edge[1]).normalized())))
					if angle < 20 or angle > 160:
						return false
		if neighbors:
			continue
		if Geometry2D.segment_intersects_segment(line[0], line[1], edge[0], edge[1]):
			return false
	return true

func is_in_list(item, lst):
	for l in lst:
		if l == item:
			return true
	return false

func get_global_container_polygon():
	var ps = PackedVector2Array()
	for p in container.polygon:
		ps.append(container.to_global(p))
	return ps
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('restart'):
		setup(10)
		queue_redraw()
	if event.is_action_pressed('clean'):
		cleanup()
		queue_redraw()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			var pos = get_global_mouse_position()
			var label = Label.new()
			label.position = pos
			# label.text = str(round(pos.x / Cs.SNAP_GRID_PIXELS)) + ", " + str(round(pos.y / Cs.SNAP_GRID_PIXELS))
			label.text = str(pos.x) + ", " + str(pos.y)
			add_child(label)

func _draw() -> void:
	for i in range(1, Cs.CONTAINER_GRID_SIZE):
		for j in range(1, Cs.CONTAINER_GRID_SIZE):
			draw_circle(Vector2(i * Cs.SNAP_GRID_PIXELS, j * Cs.SNAP_GRID_PIXELS) - Vector2(Cs.CONTAINER_EDGE_SIZE / 2, Cs.CONTAINER_EDGE_SIZE / 2), 3, Cs.BLUE)
	for edge in edges:
		draw_line(edge[0], edge[1], Cs.RED)
	for p in points:
		draw_circle(to_global(p), 3, Cs.RED)

extends Area2D

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	input_pickable = true
	print("Character bereit bei Position: ", global_position)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			print("DRAG GESTARTET – drag_offset: ", drag_offset)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			print("LOSGELASSEN bei Position: ", global_position)
			snap_to_marker()

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset

func snap_to_marker():
	var markers = get_tree().get_nodes_in_group("snap_points")
	print("Marker gefunden: ", markers.size())

	var closest_marker = null
	var best_distance = 400.0

	for m in markers:
		if m.occupied and m.occupant != self:
			continue
		var dist = global_position.distance_to(m.global_position)
		if dist < best_distance:
			best_distance = dist
			closest_marker = m

	if closest_marker:
		for m in markers:
			if m.occupant == self:
				m.occupied = false
				m.occupant = null
		global_position = closest_marker.global_position
		closest_marker.occupied = true
		closest_marker.occupant = self
		print("EINGERASTET auf: ", closest_marker.name)
	else:
		print("KEIN Marker in Reichweite!")

extends Sprite2D

var dragging := false
var drag_offset := Vector2.ZERO
var touch_index := -1  
var figur_name: String = ""

func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Nur reagieren wenn noch kein Finger diese Figur zieht
			if touch_index == -1 and _is_touch_over(event.position):
				dragging = true
				touch_index = event.index  # Finger-ID merken
				drag_offset = global_position - event.position
		else:
			if event.index == touch_index:
				dragging = false
				touch_index = -1
				snap_to_marker()
	
	# Finger bewegt sich
	if event is InputEventScreenDrag:
		if event.index == touch_index and dragging:
			global_position = event.position + drag_offset

func _is_touch_over(touch_pos: Vector2) -> bool:
	if texture == null:
		return false
	var local_touch = to_local(touch_pos)
	var tex_size = texture.get_size()
	var rect = Rect2(-tex_size / 2, tex_size)
	return rect.has_point(local_touch)
	
func snap_to_marker():
	var markers = get_tree().get_nodes_in_group("snap_points")
	var closest_marker = null
	var best_distance = 1000.0
	
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
		GameState.origami_positions[figur_name] = closest_marker.name
		print("EINGERASTET auf: ", closest_marker.name)
	else:
		print("KEIN Marker in Reichweite!")

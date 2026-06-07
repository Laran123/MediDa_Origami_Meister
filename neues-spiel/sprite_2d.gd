extends Sprite2D

var dragging := false
var drag_offset := Vector2.ZERO
var figur_name: String = ""

# dieses Script ist dazu da die Figuren per drag and drop verschiebbar zu machen
func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.pressed:
			if _is_mouse_over():
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
		else:
			if dragging:
				dragging = false
				snap_to_marker()
				
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset
		
func _is_mouse_over() -> bool:
	if texture == null:
		return false
	var local_mouse = to_local(get_global_mouse_position())
	var tex_size = texture.get_size() 
	var rect = Rect2(-tex_size / 2, tex_size)
	return rect.has_point(local_mouse)#
	
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

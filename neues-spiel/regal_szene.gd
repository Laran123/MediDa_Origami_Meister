extends Node2D

const OrigamiPreset = preload("res://origami_preset.tscn")


func _ready():
	
	var points = get_tree().get_nodes_in_group("snap_points")
	var used_points = []
	# alle gepeicherten schon angefertigten figuren werden geladen
	# und der zuvor ausgewählte PLatz
	for figur in GameState.completed_origami:
		var frame_count = _count_frames(figur)
		var sprite = OrigamiPreset.instantiate()
		add_child(sprite)
		
		# der Sprite2D wird die komplettete texture gegeben
		sprite.texture = load("res://Assets/%s/%s_%d.png" % [figur, figur.to_lower(), frame_count])
		var s = 0.18 + randf() * 0.05
		sprite.scale = Vector2(s, s)
		sprite.rotation = randf_range(-0.05, 0.05)
		sprite.figur_name = figur
		
		var point = null
		if GameState.origami_positions.has(figur):
			var saved_name = GameState.origami_positions[figur]
			point = _find_point_by_name(points, saved_name)
	
		if point == null or point.occupied:
			point = _get_free_point(points, used_points)
		   
		if point == null:
			break
		   
		sprite.position = point.global_position
		point.occupied = true
		point.occupant = sprite
		used_points.append(point)


func _get_free_point(points, used_points):
	for p in points:
		if p.occupied == false and p not in used_points:
			return p
	
	return null
	
func _find_point_by_name(points, point_name: String):
	for p in points:
		if p.name == point_name:
			return p
	return null
	
func _count_frames(figur:String)->int:
	var i = 1
	while ResourceLoader.exists(
		"res://Assets/%s/%s_%d.png"% [figur, figur.to_lower(), i]):
		i += 1
	return i - 1
	
func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")

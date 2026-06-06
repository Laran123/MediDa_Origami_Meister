extends Node2D

const TestScene = preload("res://test.tscn")
const DraggableSprite = preload("res://origami_preset.tscn")

func _ready():
	var points = get_tree().get_nodes_in_group("snap_points")
	var used_points = []
	for figur in GameState.completed_origami:
		var point = _get_free_point(points, used_points)
		if point == null:
			break
		var frame_count = _count_frames(figur)
		
		var sprite = DraggableSprite.instantiate()
		add_child(sprite)
		
		sprite.texture = load(
			"res://Assets/%s/%s_%d.png"
			 % [figur, figur.to_lower(), frame_count])
		var s = 0.18 + randf() * 0.05
		sprite.scale = Vector2(s, s)
		sprite.rotation = randf_range(-0.05, 0.05)
		sprite.position = point.global_position
		
		point.occupied = true
		point.occupant = sprite
		used_points.append(point)


func _get_free_point(points, used_points):

	for p in points:
		if p.occupied == false and p not in used_points:
			return p

	return null

func _count_frames(figur:String)->int:

	var i = 1

	while ResourceLoader.exists(
		"res://Assets/%s/%s_%d.png"
		% [figur, figur.to_lower(), i]
	):
		i += 1

	return i - 1
	
func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")

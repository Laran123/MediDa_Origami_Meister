extends Node2D

const OrigamiPreset = preload("res://origami_preset.tscn")

func _ready():
	var points = get_tree().get_nodes_in_group("snap_points")
	var used_points = []

	for figur in GameState.completed_origami:
		# Letzten Frame-Texture aus der AnimatedSprite2D-Szene holen
		var texture = _get_last_frame_texture(figur)
		if texture == null:
			push_error("Keine Textur für Figur gefunden: " + figur)
			continue

		var sprite = OrigamiPreset.instantiate()
		add_child(sprite)
		sprite.texture = texture

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

func _get_last_frame_texture(figur: String) -> Texture2D:
	var scene_path = "res://%s.tscn" % figur
	if not ResourceLoader.exists(scene_path):
		push_error("Szene nicht gefunden: " + scene_path)
		return null

	# Szene laden und AnimatedSprite2D holen
	var packed = load(scene_path)
	var instance = packed.instantiate()

	# Temporär zur Szene hinzufügen damit get_node funktioniert
	add_child(instance)
	var anim_sprite = instance.get_node("AnimatedSprite2D")

	if anim_sprite == null:
		push_error("Kein AnimatedSprite2D in: " + scene_path)
		instance.queue_free()
		return null

	# Letzten Frame der Standard-Animation holen
	var frames = anim_sprite.sprite_frames
	var anim_name = anim_sprite.animation
	var frame_count = frames.get_frame_count(anim_name)

	if frame_count == 0:
		push_error("Keine Frames in Animation: " + anim_name)
		instance.queue_free()
		return null

	# Letzten Frame als Texture holen
	var texture = frames.get_frame_texture(anim_name, frame_count - 1)

	# Temporäre Instanz wieder entfernen
	instance.queue_free()

	return texture

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

func _on_zuruck_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")

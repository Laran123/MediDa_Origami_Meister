extends Control

var figur = ""
var step = 0
var total_frames = 0
var animated_sprite: AnimatedSprite2D
var figur_scene_instance  # Referenz auf die geladene Figur-Szene

func _ready():
	_build_ui()
	_load_figur_scene()
	
func set_figur(f: String):
	figur = f
	
func _load_figur_scene():
	var scene_path = "res://%s.tscn" % figur
	
	var packed = load(scene_path)
	figur_scene_instance = packed.instantiate()

	add_child(figur_scene_instance)
	
	animated_sprite = figur_scene_instance.get_node("AnimatedSprite2D")
	
	animated_sprite.stop()
	animated_sprite.frame = 0
	
	total_frames = animated_sprite.sprite_frames.get_frame_count(
		animated_sprite.animation)
	
	call_deferred("_position_sprite")

func _position_sprite():
	if figur_scene_instance == null:
		return
	
	var vp = get_viewport_rect().size
	var sz = min(vp.x, vp.y) * 0.25
	
	figur_scene_instance.position = Vector2(vp.x / 2.0,vp.y / 2.0 + 90)
	
	var native_size = 512.0 
	var scale_factor = sz / native_size
	figur_scene_instance.scale = Vector2(scale_factor, scale_factor)
	
	if total_frames > 0:
		_update_frame()

func _update_frame():
	if animated_sprite == null:
		return
	animated_sprite.frame = step
	
func _on_next():
	if step < total_frames - 1:
		step += 1
		_update_frame()
	elif step == total_frames - 1:
		step = total_frames - 1
		_update_frame()
		_finish_origami()
		
func _on_back():
	if step > 0:
		step -= 1
		_update_frame()
	else:
		get_tree().change_scene_to_file("res://origami_wahlen.tscn")
		
func _finish_origami():
	if figur not in GameState.completed_origami:
		GameState.completed_origami.append(figur)
	var scene = load("res://success_szene.tscn").instantiate()
	scene.set_figur(figur)
	var last_texture = animated_sprite.sprite_frames.get_frame_texture(
		animated_sprite.animation, total_frames - 1
	)
	scene.set_preview_texture(last_texture)
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
	
func _build_ui():
	var bg = TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.texture = load("res://Assets/Background/Untergrund.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg)
	move_child(bg, 0)
	
	var back = Button.new()
	back.text = "ZURÜCK"
	back.custom_minimum_size = Vector2(360, 130)
	back.position = Vector2(40, 40)
	_style_button(back)
	back.add_theme_font_size_override("font_size", 32)
	back.pressed.connect(_on_back)
	add_child(back)
	
	var next = Button.new()
	next.text = "WEITER"
	next.custom_minimum_size = Vector2(460, 180)
	_style_button(next)
	next.add_theme_font_size_override("font_size", 38)
	next.pressed.connect(_on_next)
	add_child(next)
	
	next.anchor_left = 1
	next.anchor_top = 1
	next.anchor_right = 1
	next.anchor_bottom = 1
	next.offset_left = -520
	next.offset_top = -260
	next.offset_right = -40
	next.offset_bottom = -40
	
func _style_button(btn: Button):
	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.16, 0.16, 0.20)
	normal.corner_radius_top_left = 24
	normal.corner_radius_top_right = 24
	normal.corner_radius_bottom_left = 24
	normal.corner_radius_bottom_right = 24
	normal.content_margin_left = 30
	normal.content_margin_right = 30
	normal.content_margin_top = 18
	normal.content_margin_bottom = 18
	
	var hover = normal.duplicate()
	hover.bg_color = Color(0.24, 0.24, 0.32)
	
	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.10, 0.10, 0.14)
	
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)

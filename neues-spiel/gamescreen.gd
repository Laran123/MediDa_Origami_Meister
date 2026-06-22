extends Control

@onready var label_credits = $LabelCredits
var figur = ""
var step = 0
var total_frames = 0
var animated_sprite: AnimatedSprite2D
var figur_scene_instance  # Referenz auf die geladene Figur-Szene
var _next_btn: Button
var _finish_panel: Panel

func _ready():
	_build_ui()
	_load_figur_scene()
	
	if figur == 'Credits':
		label_credits.visible = true
	else:
		label_credits.visible = false
	
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
	if _finish_panel != null:
		_finish_panel.queue_free()
		_finish_panel = null
		if _next_btn != null:
			_next_btn.show()
		return
	if step > 0:
		step -= 1
		_update_frame()
	else:
		get_tree().change_scene_to_file("res://origami_wahlen.tscn")
		
func _finish_origami():

	if figur not in GameState.completed_origami:
		GameState.completed_origami.append(figur)

	if _next_btn != null:
		_next_btn.hide()

	var panel = Panel.new()
	panel.anchor_left = 0.25
	panel.anchor_top = 0.18
	panel.anchor_right = 0.75
	panel.anchor_bottom = 0.82
	panel.offset_left = 0
	panel.offset_top = 0
	panel.offset_right = 0
	panel.offset_bottom = 0
	_finish_panel = panel
	

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.10, 0.14, 0.85)
	style.set_border_width_all(3)
	style.border_color = Color(1, 1, 1, 0.5)
	style.set_corner_radius_all(20)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	
	
	var label = Label.new()
	if figur != 'Credits':
		label.text = _load_erklaerungstext()
	else:
		label.text ="""
		Credits:
			Jolien Paulinksky,
			Hai Dang,
			Laran Wolf,
			Milosz Figura"""
	label.add_theme_font_size_override("font_size", 42)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.anchor_right = 1
	label.anchor_bottom = 1
	label.offset_left = 40
	label.offset_top = 40
	label.offset_right = -40
	label.offset_bottom = -160
	panel.add_child(label)

	var ok = Button.new()
	ok.text = "OK"
	ok.custom_minimum_size = Vector2(360, 130)
	_style_button(ok)
	ok.add_theme_font_size_override("font_size", 38)
	ok.pressed.connect(_go_regal)
	panel.add_child(ok)
	ok.anchor_left = 0.5
	ok.anchor_top = 1
	ok.anchor_right = 0.5
	ok.anchor_bottom = 1
	ok.offset_left = -180
	ok.offset_top = -150
	ok.offset_right = 180
	ok.offset_bottom = -20

func _load_erklaerungstext() -> String:
	var path = "res://Erklaerungstexte.md"
	if not FileAccess.file_exists(path):
		return ""
	var f = FileAccess.open(path, FileAccess.READ)
	var text = f.get_as_text()
	f.close()
	return text

func _go_regal():
	get_tree().change_scene_to_file("res://regal_szene.tscn")
	
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
	back.add_theme_font_size_override("font_size",32)
	back.pressed.connect(_on_back)
	add_child(back)
	
	var next = Button.new()
	next.text = "WEITER"
	next.custom_minimum_size = Vector2(460, 180)
	_style_button(next)
	next.add_theme_font_size_override("font_size", 38)
	next.pressed.connect(_on_next)
	add_child(next)
	_next_btn = next

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
	hover.bg_color =  Color(0.24, 0.24, 0.32)
	
	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.10, 0.10, 0.14)
	
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
